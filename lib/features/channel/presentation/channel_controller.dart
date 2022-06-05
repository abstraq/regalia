import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/users/data/user_repository.dart";
import "package:regalia/features/users/domain/user.dart";

class ChannelScreenController extends StateNotifier<AsyncValue<User>> {
  final String _broadcasterId;
  final UserRepository _userRepository;

  ChannelScreenController(final String broadcasterId, {required UserRepository userRepository})
      : _broadcasterId = broadcasterId,
        _userRepository = userRepository,
        super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _userRepository.retrieveUser(_broadcasterId);
      if (user == null) throw Exception("User not found");
      return user;
    });
  }
}

final channelScreenControllerProvider =
    StateNotifierProvider.family.autoDispose<ChannelScreenController, AsyncValue<User>, String>(
  (ref, broadcasterId) {
    return ChannelScreenController(broadcasterId, userRepository: ref.watch(userRepositoryProvider));
  },
);
