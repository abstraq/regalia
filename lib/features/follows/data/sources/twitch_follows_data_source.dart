import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/data/helix_dio_provider.dart";
import "package:regalia/features/follows/data/entities/get_user_follows_response.dart";

class TwitchFollowsDataSource {
  final Dio _dio;

  TwitchFollowsDataSource(this._dio);

  Future<GetUserFollowsResponse> fetchUserFollows({String? userId, int first = 100, String? after}) async {
    final queryParams = <String, dynamic>{"from_id": userId ?? _dio.options.extra["User-ID"], "first": first};

    // If the call specified an 'after' cursor then add it to the query params.
    if (after != null) {
      queryParams["after"] = after;
    }

    final response = await _dio.get("/users/follows", queryParameters: queryParams);
    return GetUserFollowsResponse.fromJson(response.data);
  }

  Future<GetUserFollowsResponse> fetchUserFollowers({String? userId, int first = 100, String? after}) async {
    final queryParams = <String, dynamic>{"to_id": userId ?? _dio.options.extra["User-ID"], "first": first};

    // If the call specified an 'after' cursor then add it to the query params.
    if (after != null) {
      queryParams["after"] = after;
    }

    final response = await _dio.get("/users/follows", queryParameters: queryParams);
    return GetUserFollowsResponse.fromJson(response.data);
  }
}

final twitchFollowsDataSourceProvider = Provider<TwitchFollowsDataSource>((ref) {
  final dio = ref.watch(helixDioProvider);
  return TwitchFollowsDataSource(dio);
});
