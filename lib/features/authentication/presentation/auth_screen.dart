import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/presentation/widgets/regalia_logo.dart";
import "package:regalia/features/authentication/presentation/widgets/login_button.dart";

/// Screen displayed when the user is not authenticated.
///
/// When the user clicks the [LoginButton], the user is redirected to
/// the Twitch authentication page where they can sign in and then be
/// redirected back to the app with the access token.
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              const Expanded(child: RegaliaLogo()),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Regalia is a free, open source cross-platform mobile twitch client. "
                  "Regalia is developed by abstraq and licensed under the MIT license.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
