import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/data/interceptors/regalia_interceptor.dart";
import "package:regalia/core/domain/exceptions/illegal_state_exception.dart";
import "package:regalia/features/authentication/application/credential_service.dart";

/// Provides a [Dio] instance that can be used to make authenticated HTTP requests to the Twitch API.
///
/// This dio instance has the base URL of 'https://api.twitch.tv/helix' and [options.extra] contains
/// the 'User-ID' of the currently authenticated user.
///
/// When trying to access this instance when the user is not authenticated, an [IllegalStateException] will be thrown.
/// This provider should be read not watched.
final helixDioProvider = Provider<Dio>((ref) {
  final credentialState = ref.watch(credentialServiceProvider);
  final credentials = credentialState.whenOrNull(data: (x) => x);

  if (credentials == null) {
    throw IllegalStateException("Tried to access helix data source before the credentials were loaded.");
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: "https://api.twitch.tv/helix",
      headers: {"Authorization": "Bearer ${credentials.token}", "Client-ID": credentials.clientId},
      extra: {"User-ID": credentials.userId},
    ),
  );

  dio.interceptors.addAll([
    RegaliaInterceptor(), // Interceptor for logging and error transformation.
  ]);

  return dio;
});
