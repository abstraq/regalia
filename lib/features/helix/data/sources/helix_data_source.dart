import "package:dio/dio.dart";
import "package:fpdart/fpdart.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/domain/exceptions/illegal_state_exception.dart";
import "package:regalia/features/authentication/application/credential_service.dart";
import "package:regalia/features/authentication/domain/credentials.dart";
import "package:regalia/features/helix/data/transfer/get_users_follows_response.dart";
import "package:regalia/features/helix/data/transfer/get_users_response.dart";

class HelixDataSource {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://api.twitch.tv/helix"));
  final Credentials credentials;

  HelixDataSource({required this.credentials}) {
    _dio.options.headers["Authorization"] = "Bearer ${credentials.token}";
    _dio.options.headers["Client-ID"] = credentials.clientId;
  }

  Future<GetUsersResponse> fetchUsers({List<String>? ids}) async {
    final Map<String, dynamic> queryParams = {};

    // If the call specified ids then add them to the query params.
    if (ids != null) {
      queryParams["id"] = ListParam(ids, ListFormat.multi);
    }

    final response = await _dio.get("/users", queryParameters: queryParams);
    return GetUsersResponse.fromJson(response.data);
  }

  Future<GetUsersFollowsResponse> fetchUserFollows(final userId, {int? first, String? after}) async {
    final Map<String, dynamic> queryParams = {"from_id": userId};

    // If the call specified a 'first' limit then add it to the query params.
    if (first != null) {
      queryParams["first"] = first;
    }

    // If the call specified an 'after' cursor then add it to the query params.
    if (after != null) {
      queryParams["after"] = after;
    }

    final response = await _dio.get("/users/follows", queryParameters: queryParams);
    return GetUsersFollowsResponse.fromJson(response.data);
  }

  Future<GetUsersFollowsResponse> fetchUserFollowers(final userId, {int? first, String? after}) async {
    final Map<String, dynamic> queryParams = {"to_id": userId};

    // If the call specified a 'first' limit then add it to the query params.
    if (first != null) {
      queryParams["first"] = first;
    }

    // If the call specified an 'after' cursor then add it to the query params.
    if (after != null) {
      queryParams["after"] = after;
    }

    final response = await _dio.get("/users/follows", queryParameters: queryParams);
    return GetUsersFollowsResponse.fromJson(response.data);
  }
}

final helixDataSourceProvider = Provider<HelixDataSource>((ref) {
  final credentialState = ref.watch(credentialServiceProvider);
  final credentialsOption = credentialState.whenOrNull(data: identity);

  if (credentialsOption == null) {
    throw IllegalStateException("Tried to access helix data source before the credential state is loaded.");
  }

  final credentials = credentialsOption.getOrElse(
    () => throw IllegalStateException("Tried to access helix data source while user is not authenticated."),
  );

  return HelixDataSource(credentials: credentials);
});
