import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../core/presentation/widgets/regalia_logo.dart";
import "../../../exceptions/auth_exception.dart";
import "../../../exceptions/invalid_token_exception.dart";
import "../../../exceptions/request_exception.dart";
import "../../../exceptions/twitch_api_exception.dart";
import "../application/credential_service.dart";

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credentialState = ref.watch(credentialServiceProvider);
    final credentialService = ref.watch(credentialServiceProvider.notifier);
    // Error handling.
    ref.listen<AsyncValue>(
      credentialServiceProvider,
      (_, state) => state.whenOrNull(
        error: (error, _) {
          SnackBar snackbar = const SnackBar(content: Text("An error has occurred."));

          if (error is AuthException) {
            snackbar = SnackBar(content: Text("An error occurred during authentication: ${error.message}"));
          }

          if (error is InvalidTokenException) {
            snackbar = const SnackBar(content: Text("The token is invalid. Please sign in again."));
          }

          if (error is RequestException) {
            snackbar = const SnackBar(content: Text("An error occurred during authentication."));
          }

          if (error is TwitchAPIException) {
            snackbar = const SnackBar(content: Text("An error occurred during authentication."));
          }

          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        },
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
                  onPressed: credentialState.isLoading
                      ? null
                      : credentialState.whenOrNull<void Function()?>(
                          data: (credentials) => credentials.isNone() ? credentialService.login : null,
                        ),
                  child: const Text("Sign in"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
