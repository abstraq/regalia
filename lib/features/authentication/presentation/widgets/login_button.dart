import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/application/credential_service.dart";

/// Button for authenticating with Twitch.
class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credentialState = ref.watch(credentialServiceProvider);

    // The button should only be able to be pressed when the user is not authenticated.
    final isReady = credentialState.maybeWhen(data: (credentials) => credentials == null, orElse: () => false);

    return ElevatedButton(
      onPressed: isReady ? () => ref.read(credentialServiceProvider.notifier).login() : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: const Text("Login"),
    );
  }
}
