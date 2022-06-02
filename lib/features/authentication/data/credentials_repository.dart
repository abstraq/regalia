import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/data/sources/auth_api_data_source.dart";
import "package:regalia/features/authentication/data/sources/secure_storage_data_source.dart";
import "package:regalia/features/authentication/domain/credentials.dart";

/// This repository is responsible for storing the [Credentials] for
/// the app.
class CredentialsRepository {
  final SecureStorageDataSource _storageDataSource;
  final AuthApiDataSource _apiDataSource;

  Credentials? _cachedCredentials;

  CredentialsRepository({required SecureStorageDataSource storageDataSource, required AuthApiDataSource apiDataSource})
      : _storageDataSource = storageDataSource,
        _apiDataSource = apiDataSource;

  Future<Credentials> addCredentials(final String token) async {
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
  Future<Credentials?> retrieveCredentials() async {
    final cachedCredentials = _cachedCredentials;
    // If we have cached credentials, we can return them immediately.
    if (cachedCredentials != null) {
      return cachedCredentials;
    }

    // Otherwise, we need to fetch the credentials from the secure storage.
    final credentials = await _storageDataSource.read();
    _cachedCredentials = credentials;
    return credentials;
  }

  Future<void> deleteCredentials() async {
    final credentials = await retrieveCredentials();
    if (credentials == null) return;

    /// If the credentials are not already expired revoke the token.
    if (credentials.expiresAt.isAfter(DateTime.now())) {
      await _apiDataSource.revoke(token: credentials.token, clientId: credentials.clientId);
      await _storageDataSource.delete();
    }
    _cachedCredentials = null;
  }
}

/// Provider that provides the [CredentialsRepository] instance.
final credentialsRepositoryProvider = Provider<CredentialsRepository>((ref) {
  return CredentialsRepository(
    storageDataSource: ref.read(secureStorageDataSourceProvider),
    apiDataSource: ref.read(authApiDataSourceProvider),
  );
});
