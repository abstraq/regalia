import "package:dio/dio.dart";
import "package:fpdart/fpdart.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../domain/auth_failure.dart";
import "../domain/credentials.dart";
import "sources/secure_storage_data_source.dart";
import "sources/twitch_auth_data_source.dart";

/// Repository for authentication.
///
/// Handles authentication with Twitch and secure access to the credentials.
class AuthRepository {
  final SecureStorageDataSource _secureStorageDataSource;
  final TwitchAuthDataSource _twitchAuthDataSource;

  Credentials? _cachedCredentials;

  AuthRepository({
    required SecureStorageDataSource secureStorageDataSource,
    required TwitchAuthDataSource twitchAuthDataSource,
  })  : _secureStorageDataSource = secureStorageDataSource,
        _twitchAuthDataSource = twitchAuthDataSource;

  /// Stores credentials for the user.
  ///
  /// This method will validate the provided [accessToken] and store the credentials
  /// in the secure storage.
  ///
  /// Returns a [TaskEither] that when resolved will contain an [AuthFailure] in case
  /// of an issue or a [Unit] if the credentials were stored successfully.
  TaskEither<AuthFailure, Unit> addCredentials(final String accessToken) {
    return TaskEither(() async {
      try {
        final currentTime = DateTime.now();
        final validationResponse = await _twitchAuthDataSource.validate(accessToken);
        final credentials = Credentials(
          token: accessToken,
          userId: validationResponse.userId,
          clientId: validationResponse.clientId,
          expiresAt: currentTime.add(Duration(seconds: validationResponse.expiresIn)),
        );
        await _secureStorageDataSource.write(credentials);
        _cachedCredentials = credentials;
        return const Right(unit);
      } on DioError catch (error) {
        if (error.response?.statusCode == 401) {
          return const Left(AuthFailure("The access token is invalid."));
        }
        return Left(AuthFailure(error.message));
      }
    });
  }

  /// Retrieves credentials for the user.
  ///
  /// Returns a [Option] containing the [Credentials] if present.
  Future<Option<Credentials>> retrieveCredentials() async {
    final cachedCredentials = _cachedCredentials;
    // If we have cached credentials, we can return them immediately.
    if (cachedCredentials != null) {
      return Some(cachedCredentials);
    }

    // Otherwise, we need to fetch the credentials from the secure storage.
    final credentials = await _secureStorageDataSource.read();
    _cachedCredentials = credentials.toNullable();
    return credentials;
  }

  /// Removes credentials for the user.
  ///
  /// This method will revoke the access token and remove the credentials from the
  /// secure storage.
  TaskEither<AuthFailure, Unit> deleteCredentials() {
    return TaskEither(() async {
      final credentialsOption = await retrieveCredentials();
      return credentialsOption.match(
        (credentials) async {
          /// If the credentials are not already expired revoke the token.
          if (credentials.expiresAt.isAfter(DateTime.now())) {
            try {
              await _twitchAuthDataSource.revoke(credentials);
            } on DioError catch (error) {
              // If the error is unknown we can't delete the credentials.
              if (error.response?.statusCode != 400 || error.response?.statusCode != 404) {
                return Left(AuthFailure(error.message));
              }
            }
            await _secureStorageDataSource.delete();
          }
          return const Right(unit);
        },
        () => const Left(AuthFailure("There are no credentials to delete.")),
      );
    });
  }
}

/// Provider that provides the [AuthRepository] instance.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorageDataSource = ref.watch(secureStorageDataSourceProvider);
  final twitchAuthDataSource = ref.watch(twitchAuthDataSourceProvider);
  return AuthRepository(secureStorageDataSource: secureStorageDataSource, twitchAuthDataSource: twitchAuthDataSource);
});
