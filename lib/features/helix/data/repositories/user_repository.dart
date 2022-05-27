import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/helix/data/sources/helix_data_source.dart";
import "package:regalia/features/helix/domain/twitch_user.dart";

class UserRepository {
  final HelixDataSource _helix;

  UserRepository(this._helix);

  Future<TwitchUser> retrieveClientUser() async {
    final response = await _helix.fetchUsers();
    return TwitchUser.fromUserInformation(response.data.first);
  }

  Future<TwitchUser> retrieveUser(final String id) async {
    final response = await _helix.fetchUsers(ids: [id]);
    return TwitchUser.fromUserInformation(response.data.first);
  }

  Future<List<TwitchUser>> retrieveUsers(final List<String> ids) async {
    final response = await _helix.fetchUsers(ids: ids);
    return response.data.map(TwitchUser.fromUserInformation).toList();
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.watch(helixDataSourceProvider);
  return UserRepository(dataSource);
});
