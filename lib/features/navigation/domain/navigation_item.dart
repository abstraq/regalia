import "package:freezed_annotation/freezed_annotation.dart";
import "package:regalia/features/users/domain/user.dart";

part "navigation_item.freezed.dart";

@freezed
class NavigationItem with _$NavigationItem {
  const factory NavigationItem.channel({
    required User broadcaster,
    required bool ephemeral,
  }) = _ChannelNavigationItem;
}
