import "package:freezed_annotation/freezed_annotation.dart";

part "get_users_response.freezed.dart";
part "get_users_response.g.dart";

@freezed
class GetUsersResponse with _$GetUsersResponse {
  const factory GetUsersResponse({required List<UserInformationPayload> data}) = _GetUsersResponse;

  factory GetUsersResponse.fromJson(Map<String, dynamic> json) => _$GetUsersResponseFromJson(json);
}

@freezed
class UserInformationPayload with _$UserInformationPayload {
  const factory UserInformationPayload({
    required String id,
    required String login,
    @JsonKey(name: "display_name") required String displayName,
    required String type,
    @JsonKey(name: "broadcaster_type") required String broadcasterType,
    required String description,
    @JsonKey(name: "profile_image_url") required String profileImageUrl,
    @JsonKey(name: "offline_image_url") required String offlineImageUrl,
    @JsonKey(name: "created_at") required DateTime createdAt,
  }) = _UserInformationPayload;

  factory UserInformationPayload.fromJson(Map<String, dynamic> json) => _$UserInformationPayloadFromJson(json);
}
