import "package:freezed_annotation/freezed_annotation.dart";
import "package:regalia/core/data/entities/pagination_object.dart";

part "get_user_follows_response.freezed.dart";
part "get_user_follows_response.g.dart";

@freezed
class GetUserFollowsResponse with _$GetUserFollowsResponse {
  const factory GetUserFollowsResponse({
    required int total,
    required List<UserFollowPayload> data,
    required PaginationObject pagination,
  }) = _GetUserFollowsResponse;

  factory GetUserFollowsResponse.fromJson(Map<String, dynamic> json) => _$GetUserFollowsResponseFromJson(json);
}

@freezed
class UserFollowPayload with _$UserFollowPayload {
  const factory UserFollowPayload({
    @JsonKey(name: "from_id") required String fromId,
    @JsonKey(name: "from_login") required String fromLogin,
    @JsonKey(name: "from_name") required String fromName,
    @JsonKey(name: "to_id") required String toId,
    @JsonKey(name: "to_login") required String toLogin,
    @JsonKey(name: "to_name") required String toName,
    @JsonKey(name: "followed_at") required DateTime followedAt,
  }) = _UserFollowPayload;

  factory UserFollowPayload.fromJson(Map<String, dynamic> json) => _$UserFollowPayloadFromJson(json);
}
