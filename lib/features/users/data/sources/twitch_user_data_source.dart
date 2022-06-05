import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/data/helix_dio_provider.dart";
import "package:regalia/features/users/data/entities/get_users_response.dart";

/// Data source for interacting with the User resource on the Twitch API.
class TwitchUserDataSource {
  final Dio _dio;

  TwitchUserDataSource(this._dio);

  Future<GetUsersResponse> fetchUsers({List<String>? ids}) async {
    final queryParams = <String, dynamic>{};

    // If the call specified ids then add them to the query params.
    if (ids != null) {
      queryParams["id"] = ListParam(ids, ListFormat.multi);
    }

    final response = await _dio.get("/users", queryParameters: queryParams);
    return GetUsersResponse.fromJson(response.data);
  }

  String clientUserId() => _dio.options.extra["User-ID"];
}

final twitchUserDataSourceProvider = Provider.autoDispose<TwitchUserDataSource>((ref) {
  final dio = ref.watch(helixDioProvider);
  return TwitchUserDataSource(dio);
});
