import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/helix/data/repositories/user_repository.dart";
import "package:regalia/features/helix/domain/twitch_user.dart";

class ClientUserService extends StateNotifier<AsyncValue<TwitchUser>> {
  final UserRepository _repository;

  ClientUserService(this._repository) : super(const AsyncValue.loading()) {
    loadClientUser();
  }

  Future<void> loadClientUser() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.retrieveClientUser());
  }
}

final clientUserServiceProvider = StateNotifierProvider.autoDispose<ClientUserService, AsyncValue<TwitchUser>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return ClientUserService(repository);
});
