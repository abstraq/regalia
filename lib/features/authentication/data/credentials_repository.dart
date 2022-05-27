import "package:fpdart/fpdart.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/data/sources/secure_storage_data_source.dart";
import "package:regalia/features/authentication/data/sources/twitch_auth_api_data_source.dart";
import "package:regalia/features/authentication/data/sources/twitch_auth_browser_data_source.dart";
import "package:regalia/features/authentication/domain/credentials.dart";

class CredentialsRepository {
  final SecureStorageDataSource _storageDataSource;
  final TwitchAuthApiDataSource _apiDataSource;
  final TwitchAuthBrowserDataSource _browserDataSource;

  Credentials? _cachedCredentials;

  CredentialsRepository({
    required SecureStorageDataSource storageDataSource,
    required TwitchAuthApiDataSource apiDataSource,
    required TwitchAuthBrowserDataSource browserDataSource,
  })  : _storageDataSource = storageDataSource,
        _apiDataSource = apiDataSource,
        _browserDataSource = browserDataSource;

  Future<Credentials> addCredentials() async {
    // Performs the OAuth2 flow in the browser and return the token.
    final token = await _browserDataSource.authorize();
    final validationResponse = await _apiDataSource.validate(token);
    final currentTime = DateTime.now();
    final expiresIn = Duration(seconds: validationResponse.expiresIn);
    final expiresAt = currentTime.add(expiresIn);

    // Construct a credential object from the response.
    final credentials = Credentials(
      token: token,
      userId: validationResponse.userId,
      clientId: validationResponse.clientId,
      expiresAt: expiresAt,
    );

    // Store the credentials in the secure storage and cache it.
    await _storageDataSource.write(credentials);
    _cachedCredentials = credentials;

    // Return the credentials.
    return credentials;
  }

  /// Retrieves credentials for the user.
  ///
  /// Returns a [Option] containing the [Credentials] if present.
  Future<Option<Credentials>> retrieveCredentials() async {
    final cachedCredentials = _cachedCredentials;
    // If we have cached credentials, we can return them immediately.
    if (cachedCredentials != null) {
      return Option.of(cachedCredentials);
    }

    // Otherwise, we need to fetch the credentials from the secure storage.
    final credentials = await _storageDataSource.read();
    _cachedCredentials = credentials.toNullable();
    return credentials;
  }

  Future<void> deleteCredentials() async {
    final credentialsOption = await retrieveCredentials();
    credentialsOption.map(
      (credentials) async {
        /// If the credentials are not already expired revoke the token.
        if (credentials.expiresAt.isAfter(DateTime.now())) {
          await _apiDataSource.revoke(token: credentials.token, clientId: credentials.clientId);
          await _storageDataSource.delete();
        }
      },
    );
  }
}

/// Provider that provides the [CredentialsRepository] instance.
final credentialsRepositoryProvider = Provider<CredentialsRepository>((ref) {
  final storageDataSource = ref.watch(secureStorageDataSourceProvider);
  final apiDataSource = ref.watch(twitchAuthApiDataSourceProvider);
  final browserDataSource = ref.read(twitchAuthBrowserDataSourceProvider);
  return CredentialsRepository(
    storageDataSource: storageDataSource,
    apiDataSource: apiDataSource,
    browserDataSource: browserDataSource,
  );
});
