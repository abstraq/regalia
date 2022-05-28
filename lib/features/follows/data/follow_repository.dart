import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/follows/data/sources/twitch_follows_data_source.dart";
import "package:regalia/features/follows/domain/follow.dart";

class FollowRepository {
  final TwitchFollowsDataSource _twitchFollowsDataSource;

  FollowRepository({required TwitchFollowsDataSource twitchFollowsDataSource})
      : _twitchFollowsDataSource = twitchFollowsDataSource;

  /// Retrieves follows for the client user.
  Future<List<Follow>> retrieveClientFollows({String? cursor}) async {
    final response = await _twitchFollowsDataSource.fetchUserFollows(after: cursor);
    final follows = response.data
        .map((follow) => Follow(
              broadcasterId: follow.toId,
              broadcasterLogin: follow.toLogin,
              broadcasterDisplayName: follow.toName,
              followedAt: follow.followedAt,
            ))
        .toList();
    if (response.pagination.cursor != null) {
      final nextFollows = await retrieveClientFollows(cursor: response.pagination.cursor);
      follows.addAll(nextFollows);
    }
    return follows;
  }
}

final followRepositoryProvider = Provider<FollowRepository>((ref) {
  return FollowRepository(
    twitchFollowsDataSource: ref.watch(twitchFollowsDataSourceProvider),
  );
});
