import "package:freezed_annotation/freezed_annotation.dart";

part "auth_failure.freezed.dart";

/// Used to describe a failure that occurred during the authentication process.
///
/// This class is used for expected failures. If an unrecoverable error occurred,
/// use an Exception instead.
@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure(final String message) = _AuthFailure;
}
