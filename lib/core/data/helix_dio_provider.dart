import "package:dio/dio.dart";
import "package:fpdart/fpdart.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/domain/exceptions/illegal_state_exception.dart";
import "package:regalia/features/authentication/application/credential_service.dart";

final helixDioProvider = Provider<Dio>((ref) {
  final credentialState = ref.watch(credentialServiceProvider);
  final credentialsOption = credentialState.whenOrNull(data: identity);

  if (credentialsOption == null) {
    throw IllegalStateException("Tried to access helix data source before the credential state is loaded.");
  }

  final credentials = credentialsOption.getOrElse(
    () => throw IllegalStateException("Tried to access helix data source while user is not authenticated."),
  );

  final dio = Dio(
    BaseOptions(
      baseUrl: "https://api.twitch.tv/helix",
      headers: {
        "Authorization": "Bearer ${credentials.token}",
        "Client-ID": credentials.clientId,
      },
      extra: {
        "User-ID": credentials.userId,
      },
    ),
  );
  dio.interceptors.add(LogInterceptor(responseBody: true, requestHeader: false));
  return dio;
});