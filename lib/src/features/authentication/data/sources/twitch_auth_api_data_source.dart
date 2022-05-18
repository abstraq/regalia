import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../exceptions/invalid_token_exception.dart";
import "../../../../exceptions/request_exception.dart";
import "../../../../exceptions/twitch_api_exception.dart";
import "../transfer/twitch_validation_response.dart";

/// Data source that provides access to the Twitch ID API.
///
/// This data source is used to validate and revoke credentials.
class TwitchAuthApiDataSource {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://id.twitch.tv/oauth2", connectTimeout: 5000, receiveTimeout: 3000));

  /// Checks if the given [token] is valid.
  ///
  /// [token] is the token to be validated.
  ///
  /// Throws a [RequestException] if the request failed to send. Throws a [InvalidTokenException] if the token is
  /// invalid. Throws a [TwitchAPIException] if the api responded with an invalid status.
  ///
  /// Returns a [TwitchValidationResponse] if the credentials are valid.
  Future<TwitchValidationResponse> validate(final String token) async {
    try {
      final response = await _dio.get(
        "/validate",
        options: Options(headers: {"Authorization": "OAuth $token"}),
      );
      return TwitchValidationResponse.fromJson(response.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        final response = e.response!;
        if (response.statusCode == 401) {
          throw const InvalidTokenException();
        }
        throw TwitchAPIException(statusCode: response.statusCode, message: response.statusMessage);
      }

      throw RequestException(e.message);
    }
  }

  /// Revokes the given [token].
  ///
  /// [token] is the token to be revoked.
  /// [clientId] is the client id of the application that provided the token.
  ///
  /// Throws a [DioError] if an error occurred while revoking the credentials.
  Future<void> revoke({required String token, required String clientId}) async {
    try {
      await _dio.post(
        "/revoke",
        data: {"token": token, "client_id": clientId},
        options: Options(contentType: "application/x-www-form-urlencoded"),
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        final response = e.response!;
        throw TwitchAPIException(statusCode: response.statusCode, message: response.statusMessage);
      }

      throw RequestException(e.message);
    }
  }
}

/// Provider that provides the [TwitchAuthApiDataSource] instance.
final twitchAuthApiDataSourceProvider = Provider<TwitchAuthApiDataSource>((_) => TwitchAuthApiDataSource());
