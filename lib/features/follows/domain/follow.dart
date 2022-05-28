import "package:freezed_annotation/freezed_annotation.dart";

part "follow.freezed.dart";

@freezed
class Follow with _$Follow {
  const factory Follow({
    required String broadcasterId,
    required String broadcasterLogin,
    required String broadcasterDisplayName,
    required DateTime followedAt,
  }) = _Follow;
}
