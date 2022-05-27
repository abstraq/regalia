import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/helix/application/client_user_service.dart";

class ClientUserDrawerFooter extends ConsumerWidget {
  const ClientUserDrawerFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientUser = ref.watch(clientUserServiceProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: double.infinity,
      child: clientUser.maybeWhen(
        data: (user) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(user.profileImageUrl), radius: 18),
                  Text(
                    "Logged in as ${user.displayName}",
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          );
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
