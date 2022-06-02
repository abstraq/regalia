import "package:freezed_annotation/freezed_annotation.dart";

part "twitch_validation_response.freezed.dart";
part "twitch_validation_response.g.dart";

/// Data transfer object that represents the response from the Twitch ID API
/// when validating an access token.
///
/// See https://dev.twitch.tv/docs/authentication/validate-tokens for more information.
@freezed
class TwitchValidationResponse with _$TwitchValidationResponse {
  const factory TwitchValidationResponse({
    @JsonKey(name: "client_id") required String clientId,
    required String login,
    required List<String> scopes,
    @JsonKey(name: "user_id") required String userId,
    @JsonKey(name: "expires_in") required int expiresIn,
  }) = _TwitchValidationResponse;

  factory TwitchValidationResponse.fromJson(Map<String, dynamic> json) => _$TwitchValidationResponseFromJson(json);
}
