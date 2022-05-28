import "package:freezed_annotation/freezed_annotation.dart";

part "pagination_object.freezed.dart";
part "pagination_object.g.dart";

@freezed
class PaginationObject with _$PaginationObject {
  const factory PaginationObject({String? cursor}) = _PaginationObject;

  factory PaginationObject.fromJson(Map<String, dynamic> json) => _$PaginationObjectFromJson(json);
}
