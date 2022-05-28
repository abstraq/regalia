import "dart:convert";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:fpdart/fpdart.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/domain/credentials.dart";

/// Data source that provides access to the [FlutterSecureStorage].
///
/// This data source is used to store and retrieve the [Credentials] in the secure storage.
///
/// On Android, the secure storage uses the Keystore to store the credentials. On iOS, the
/// secure storage uses the Keychain.
class SecureStorageDataSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
    aOptions: AndroidOptions(encryptedSharedPreferences: true, resetOnError: true),
  );

  /// Persists the credentials to the [FlutterSecureStorage]. If there are already credentials
  /// stored, they will be overwritten.
  ///
  /// [credentials] are the credentials to be persisted.
  ///
  /// Throws [PlatformException] if an error occurred while writing it to the secure
  /// storage for the platform.
  Future<void> write(final Credentials credentials) async {
    final serializedCredentials = json.encode(credentials.toJson());
    await _storage.write(key: "twitch_credentials", value: serializedCredentials);
  }

  /// Retrieves the credentials from the [FlutterSecureStorage].
  ///
  /// Throws [PlatformException] if an error occurred while reading it from the secure
  /// storage.
  ///
  /// Returns an [Option] containing the credentials if present.
  Future<Option<Credentials>> read() async {
    final serializedCredentials = await _storage.read(key: "twitch_credentials");
    if (serializedCredentials == null) return Option<Credentials>.none();
    final credentials = Credentials.fromJson(json.decode(serializedCredentials));
    return Option.of(credentials);
  }

  /// Deletes the credentials from the [FlutterSecureStorage].
  ///
  /// Throws [PlatformException] if an error occurred while deleting it from the secure
  /// storage.
  Future<void> delete() async {
    await _storage.delete(key: "twitch_credentials");
  }
}

/// Provider that provides the [SecureStorageDataSource] instance.
final secureStorageDataSourceProvider = Provider<SecureStorageDataSource>((_) => SecureStorageDataSource());
