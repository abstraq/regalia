import "dart:convert";
import "dart:developer" as developer;
import "dart:math";

import "package:flutter_inappwebview/flutter_inappwebview.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/application/auth_browser.dart";
import "package:regalia/features/authentication/data/credentials_repository.dart";
import "package:regalia/features/authentication/domain/credentials.dart";

/// This service is responsible for managing authentication with Twitch API.
///
/// When the app contains a valid token the state will contain the [Credentials]
/// otherwise the state will be empty.
class CredentialService extends StateNotifier<AsyncValue<Credentials?>> {
  final CredentialsRepository _repository;
  final String _clientId = "gsdtg68u4m4oxyumg716uz902ujsvz"; // cspell:disable-line

  final List<String> scopes = [
    "user:read:follows",
    "user:read:subscriptions",
    "user:read:blocked_users",
    "user:manage:blocked_users",
    "channel:moderate",
    "chat:edit",
    "chat:read",
    "whispers:read",
    "whispers:edit"
  ];

  CredentialService(this._repository) : super(const AsyncValue.loading()) {
    load();
  }

  /// Authenticates the user and stores the created [Credentials].
  ///
  /// If an error occurs while authenticating the user, the state is updated
  /// with the error and then [load] is called to refresh the state.
  Future<void> login() async {
    developer.log(name: "CredentialService", "Starting authentication process...");
    state = const AsyncValue.loading();
    try {
      // Open a web browser to the Twitch authentication page so the user can sign in.
      final stateToken = base64Url.encode(List.generate(21, (i) => Random.secure().nextInt(256)));
      final authorizationUrl = Uri.https("id.twitch.tv", "/oauth2/authorize", {
        "client_id": _clientId,
        "redirect_uri": "rglia://",
        "response_type": "token",
        "scope": scopes.join(" "),
        "state": stateToken,
        "force_verify": "true"
      });
      final browser = AuthBrowser(stateToken: stateToken);
      final browserOptions = ChromeSafariBrowserClassOptions(
        android: AndroidChromeCustomTabsOptions(noHistory: true, shareState: CustomTabsShareState.SHARE_STATE_OFF),
        ios: IOSSafariOptions(dismissButtonStyle: IOSSafariDismissButtonStyle.CANCEL),
      );

      await browser.open(url: authorizationUrl, options: browserOptions);
      final token = await browser.accessToken();
      final credentials = await _repository.addCredentials(token);
      state = AsyncValue.data(credentials);
      developer.log(name: "CredentialService", "Successfully logged in with user id ${credentials.userId}!");
    } catch (e) {
      developer.log(name: "CredentialService", "An error occurred while authenticating:", error: e);
      state = AsyncValue.error(e);
      await load();
    }
  }

  /// Deletes the stored [Credentials] and revokes the access token.
  ///
  /// If an error occurs while revoking the token, the state is updated
  /// with the error and then [load] is called to refresh the state.
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      developer.log(name: "CredentialService", "Starting log out process...");
      await _repository.deleteCredentials();
      state = const AsyncValue.data(null);
      developer.log(name: "CredentialService", "Successfully logged out!");
    } catch (e) {
      developer.log(name: "CredentialService", "An error occurred while logging out, refreshing state...", error: e);
      state = AsyncValue.error(e);
      await load();
    }
  }

  /// Loads the [Credentials] from the repository.
  Future<void> load() async {
    state = const AsyncValue.loading();
    developer.log(name: "CredentialService", "Loading credentials...");
    state = await AsyncValue.guard(() async {
      final credentials = await _repository.retrieveCredentials();
      developer.log(name: "CredentialService", credentials == null ? "No credentials found." : "Loaded credentials.");
      return credentials;
    });
  }
}

/// [StateNotifierProvider] that provides the [CredentialService].
final credentialServiceProvider = StateNotifierProvider<CredentialService, AsyncValue<Credentials?>>((ref) {
  final credentialsRepository = ref.watch(credentialsRepositoryProvider);
  return CredentialService(credentialsRepository);
});
