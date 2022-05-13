import "package:dio/dio.dart";

import "../../domain/credentials.dart";
import "../transfer/twitch_validation_response.dart";

/// Data source that provides access to the Twitch ID API.
///
/// This data source is used to validate and revoke credentials.
class TwitchAuthDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://id.twitch.tv/oauth2",
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  );

  /// Checks if the token in the given [credentials] is valid.
  ///
  /// [credentials] are the [Credentials] to be validated.
  ///
  /// Throws a [DioError] if an error occurred while validating the credentials.
  ///
  /// Returns a [TwitchValidationResponse] if the credentials are valid.
  Future<TwitchValidationResponse> validate(final String token) async {
    final response = await _dio.get(
      "/validate",
      options: Options(headers: {"Authorization": "OAuth $token"}),
    );
    return TwitchValidationResponse.fromJson(response.data);
  }

  /// Revokes the token in the given [credentials].
  ///
  /// [credentials] are the [Credentials] to be revoked.
  ///
  /// Throws a [DioError] if an error occurred while revoking the credentials.
  Future<void> revoke(final Credentials credentials) async {
    await _dio.post(
      "/revoke",
      data: {"token": credentials.token, "client_id": credentials.clientId},
      options: Options(contentType: "application/x-www-form-urlencoded"),
    );
  }
}
