import "package:freezed_annotation/freezed_annotation.dart";

part "user.freezed.dart";

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String login,
    required String displayName,
    required String description,
    required String profileImageUrl,
    required String offlineImageUrl,
    required DateTime createdAt,
    required String broadcasterType,
    required String staffRole,
  }) = _User;
}
