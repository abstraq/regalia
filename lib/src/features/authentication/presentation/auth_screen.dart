import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/presentation/widgets/regalia_logo.dart";
import "../application/auth_notifier.dart";

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    ref.listen<AuthState>(
      authNotifierProvider,
      (_, state) => state.whenOrNull(
        error: (message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              const Expanded(child: RegaliaLogo()),
              const Spacer(),
              const Text(
                "Regalia is a free, open source cross-platform mobile twitch client. "
                "Regalia is developed by abstraq and licensed under the MIT license.",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: authState.whenOrNull(unauthenticated: () => authNotifier.login),
                    child: const Text("Login")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
