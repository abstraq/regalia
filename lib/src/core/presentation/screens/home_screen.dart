import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../features/authentication/application/auth_notifier.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      drawer: Drawer(
          child: Expanded(
        child: Row(
          children: [
            ListView(
              children: const [
                CircleAvatar(),
                CircleAvatar(),
                CircleAvatar(),
                CircleAvatar(),
                CircleAvatar(),
                CircleAvatar(),
              ],
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () {
          ref.read(authNotifierProvider.notifier).logout();
        },
      ),
    );
  }
}
