import "package:dcache/dcache.dart";
import "package:fpdart/fpdart.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/users/data/sources/twitch_user_data_source.dart";
import "package:regalia/features/users/domain/user.dart";

/// Repository for handling [User] domain objects.
///
/// This repository handles retrieving and caching [User]s from the Twitch API.
/// The cache is a [LruCache] with a maximum size of 1000 items.
class UserRepository {
  final TwitchUserDataSource _userDataSource;
  final Cache<String, User> _cache = LruCache(storage: InMemoryStorage(1000));

  UserRepository(this._userDataSource);

  /// Retrieves [User]s in bulk.
  ///
  /// [ids] is a list of user IDs to retrieve.
  ///
  /// Since this is a bulk call, the cache is ignored and the [User]s are always retrieved from the API.
  /// Upon retrieval the [User]s are cached for future use.
  ///
  /// Returns a list of [User]s that were able to be retrieved.
  Future<List<User>> retrieveUsers(final List<String> ids) async {
    final response = await _userDataSource.fetchUsers(ids: ids);
    return response.data.map((payload) {
      final user = User(
        id: payload.id,
        login: payload.login,
        createdAt: payload.createdAt,
        displayName: payload.displayName,
        broadcasterType: payload.broadcasterType,
        offlineImageUrl: payload.offlineImageUrl,
        profileImageUrl: payload.profileImageUrl,
        staffRole: payload.type,
      );
      _cache.set(user.id, user);
      return user;
    }).toList();
  }

  /// Retrieves a single [User].
  ///
  /// [id] is the ID of the [User] to retrieve.
  ///
  /// By default the [User] is retrieved from the cache. If the [User] is not
  /// in the cache then it is retrieved from the API. To skip the cache and
  /// retrieve the [User] from the API, set [bypassCache] to true.
  ///
  /// Returns an [Option] containing the [User] if it was able to be retrieved.
  Future<Option<User>> retrieveUser(final String id, {bool bypassCache = false}) async {
    if (!bypassCache) {
      final cachedUser = _cache.get(id);
      if (cachedUser != null) {
        return Option.of(cachedUser);
      }
    }

    final users = await retrieveUsers([id]);
    return users.firstOption;
  }

  Future<User> retrieveClientUser({bool bypassCache = false}) async {
    final clientUserId = _userDataSource.clientUserId();
    if (!bypassCache) {
      final cachedUser = _cache.get(clientUserId);
      if (cachedUser != null) {
        return cachedUser;
      }
    }
    final users = await retrieveUsers([clientUserId]);
    return users.first;
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(twitchUserDataSourceProvider));
});
