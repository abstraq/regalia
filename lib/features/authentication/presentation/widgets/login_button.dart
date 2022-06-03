import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/presentation/shadows.dart";
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
        elevation: AppShadows.darkElevation02.spreadRadius,
        shadowColor: AppShadows.darkElevation02.color,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text("Login"),
    );
  }
}
