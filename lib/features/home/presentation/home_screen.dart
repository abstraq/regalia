import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/application/credential_service.dart";
import "package:regalia/features/navigation/presentation/navigation_drawer.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: Theme.of(context).textTheme.titleMedium),
        titleSpacing: 0,
        centerTitle: false,
      ),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      drawer: const NavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(credentialServiceProvider.notifier).logout();
        },
      ),
    );
  }
}
