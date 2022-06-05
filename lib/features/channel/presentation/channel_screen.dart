import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/application/credential_service.dart";
import "package:regalia/features/channel/presentation/channel_controller.dart";
import "package:regalia/features/navigation/presentation/navigation_drawer.dart";

/// Screen that displays a broadcast if the broadcaster is live and chat box.
class ChannelScreen extends ConsumerWidget {
  final String _broadcasterId;

  const ChannelScreen(final String broadcasterId, {super.key}) : _broadcasterId = broadcasterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(channelScreenControllerProvider(_broadcasterId));
    return user.when(
      data: (broadcaster) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              broadcaster.displayName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            titleSpacing: 0,
            centerTitle: false,
          ),
          drawerEdgeDragWidth: MediaQuery.of(context).size.width,
          drawer: NavigationDrawer(
            children: [
              Text(broadcaster.displayName, style: Theme.of(context).textTheme.titleMedium),
              Text(broadcaster.description, style: Theme.of(context).textTheme.bodySmall),
              const Divider()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ref.read(credentialServiceProvider.notifier).logout();
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text("Error")),
    );
  }
}
