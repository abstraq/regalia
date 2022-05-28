import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/users/data/user_repository.dart";

class ClientUserAvatar extends HookConsumerWidget {
  const ClientUserAvatar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepository = ref.watch(userRepositoryProvider);
    final getClientUserRequest = useMemoized(userRepository.retrieveClientUser, []);
    final clientUser = useFuture(getClientUserRequest);
    return clientUser.hasData
        ? CircleAvatar(backgroundImage: NetworkImage(clientUser.data!.profileImageUrl))
        : const CircleAvatar(backgroundColor: Colors.grey);
  }
}
