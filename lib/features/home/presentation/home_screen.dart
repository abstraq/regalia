import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/application/credential_service.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () {
          ref.read(credentialServiceProvider.notifier).logout();
        },
      ),
    );
  }
}
