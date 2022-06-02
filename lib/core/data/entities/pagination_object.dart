import "package:freezed_annotation/freezed_annotation.dart";

part "pagination_object.freezed.dart";
part "pagination_object.g.dart";

/// DTO that represents the pagination object that twitch sends
/// with resources that can have paginated requests.
@freezed
class PaginationObject with _$PaginationObject {
  const factory PaginationObject({String? cursor}) = _PaginationObject;

  factory PaginationObject.fromJson(Map<String, dynamic> json) => _$PaginationObjectFromJson(json);
}
