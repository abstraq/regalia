import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/data/interceptors/regalia_interceptor.dart";
import "package:regalia/features/authentication/data/entities/twitch_validation_response.dart";

/// Data source that provides access to the Twitch ID API.
///
/// This data source is used to validate and revoke credentials.
class AuthApiDataSource {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://id.twitch.tv/oauth2", connectTimeout: 5000, receiveTimeout: 3000));

  AuthApiDataSource() {
    _dio.interceptors.add(RegaliaInterceptor());
  }

  /// Checks if the given [token] is valid.
  ///
  /// [token] is the token to be validated.
  ///
  /// Returns a [TwitchValidationResponse] if the credentials are valid.
  Future<TwitchValidationResponse> validate(final String token) async {
    final response = await _dio.get("/validate", options: Options(headers: {"Authorization": "OAuth $token"}));
    return TwitchValidationResponse.fromJson(response.data);
  }

  /// Revokes the given [token].
  ///
  /// [token] is the token to be revoked.
  /// [clientId] is the client id of the application that provided the token.
  Future<void> revoke({required String token, required String clientId}) async {
    final requestPayload = {"client_id": clientId, "token": token};
    final requestOptions = Options(contentType: "application/x-www-form-urlencoded");
    await _dio.post("/revoke", data: requestPayload, options: requestOptions);
  }
}

/// [Provider] that provides the [AuthApiDataSource] instance.
final authApiDataSourceProvider = Provider<AuthApiDataSource>((_) => AuthApiDataSource());
