import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/users/data/sources/twitch_user_data_source.dart";
import "package:regalia/features/users/domain/user.dart";

/// Repository for handling [User] domain objects.
///
/// This repository handles retrieving [User]s from the Twitch API.
class UserRepository {
  final TwitchUserDataSource _userDataSource;

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
        description: payload.description,
        broadcasterType: payload.broadcasterType,
        offlineImageUrl: payload.offlineImageUrl,
        profileImageUrl: payload.profileImageUrl,
        staffRole: payload.type,
      );
      return user;
    }).toList();
  }

  /// Retrieves a single [User].
  ///
  /// [id] is the ID of the [User] to retrieve.
  ///
  /// Returns an [Option] containing the [User] if it was found.
  Future<User?> retrieveUser(final String id) async {
    final users = await retrieveUsers([id]);
    return users.isNotEmpty ? users.first : null;
  }

  Future<User> retrieveClientUser({bool bypassCache = false}) async {
    final users = await retrieveUsers([_userDataSource.clientUserId()]);
    return users.first;
  }
}

final userRepositoryProvider = Provider.autoDispose<UserRepository>((ref) {
  final dataSource = ref.watch(twitchUserDataSourceProvider);
  return UserRepository(dataSource);
});
