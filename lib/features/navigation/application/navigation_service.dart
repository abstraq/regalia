import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/follows/data/follow_repository.dart";
import "package:regalia/features/navigation/domain/navigation_item.dart";
import "package:regalia/features/users/data/user_repository.dart";

class NavigationService extends StateNotifier<AsyncValue<List<NavigationItem>>> {
  final FollowRepository _followRepository;
  final UserRepository _userRepository;

  NavigationService({required FollowRepository followRepository, required UserRepository userRepository})
      : _followRepository = followRepository,
        _userRepository = userRepository,
        super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final follows = await _followRepository.retrieveClientFollows();
      final users = await _userRepository.retrieveUsers(follows.map((follow) => follow.broadcasterId).toList());
      return users.map((user) => NavigationItem.channel(broadcaster: user, ephemeral: false)).toList();
    });
  }
}

final navigationServiceProvider =
    StateNotifierProvider.autoDispose<NavigationService, AsyncValue<List<NavigationItem>>>((ref) {
  return NavigationService(
    followRepository: ref.watch(followRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  );
});
