import "package:freezed_annotation/freezed_annotation.dart";

part "credentials.freezed.dart";
part "credentials.g.dart";

/// Data class containing the credentials for a Twitch user.
///
/// This class contains the information obtained when validating the
/// access token.
@freezed
class Credentials with _$Credentials {
  const factory Credentials({
    required String token,
    required String userId,
    required String clientId,
    required DateTime expiresAt,
  }) = _Credentials;

  factory Credentials.fromJson(Map<String, dynamic> json) => _$CredentialsFromJson(json);
}
