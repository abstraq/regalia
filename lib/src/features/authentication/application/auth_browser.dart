import "dart:convert";
import "dart:math";

import "package:flutter_inappwebview/flutter_inappwebview.dart";
import "package:fpdart/fpdart.dart";
import "package:uni_links/uni_links.dart";

import "../domain/auth_failure.dart";

class AuthBrowser extends ChromeSafariBrowser {
  static const String _clientId = "gsdtg68u4m4oxyumg716uz902ujsvz"; // cspell:disable-line

  static const List<String> scopes = [
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

  /// Opens a [Chrome Custom Tab](https://developer.android.com/reference/android/support/customtabs/package-summary) on
  /// Android or [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
  /// on iOS for the user to authenticate.
  ///
  /// The app will then listen for deep links to `me.abstraq.regalia://oauth2` containing the access token.
  ///
  /// Returns a [TaskEither] containing a [AuthFailure] if there was an error while authenticating or the access token
  /// if the user successfully authenticating.
  TaskEither<AuthFailure, String> authorize() {
    return TaskEither(() async {
      final stateToken = _generateStateToken();
      final authorizationUrl = Uri.https("id.twitch.tv", "/oauth2/authorize", {
        "client_id": _clientId,
        "redirect_uri": "https://abstraq.me/tsuru/oauth2",
        "response_type": "token",
        "scope": scopes.join(" "),
        "state": stateToken,
        "force_verify": "true"
      });
      // Open the browser with the twitch authorization page.
      await open(
        url: authorizationUrl,
        options: ChromeSafariBrowserClassOptions(
          android: AndroidChromeCustomTabsOptions(
            shareState: CustomTabsShareState.SHARE_STATE_OFF,
            showTitle: false,
            noHistory: true,
            enableUrlBarHiding: true,
          ),
        ),
      );
      // wait for the first deep link to me.abstraq.regalia://oauth2
      final link = await uriLinkStream.firstWhere((url) {
        return url?.scheme == "me.abstraq.regalia" && url?.host == "oauth2";
      });
      await close();

      if (link == null) {
        return const Left(AuthFailure("Did not receive an access token. Please try again."));
      }

      // Check if the deep link contained an error.
      if (link.queryParameters.containsKey("error")) {
        if (link.queryParameters["state"] != stateToken) {
          return const Left(AuthFailure("The state token did not match. Please try again."));
        }
        return const Left(AuthFailure("You did not authorize the app."));
      }

      // Parse the deep link and return the access token.
      final fragmentParameters = Uri.splitQueryString(link.fragment);

      // Check if the state token is valid.
      if (fragmentParameters["state"] != stateToken) {
        return const Left(AuthFailure("The state token did not match. Please try again."));
      }

      final accessToken = fragmentParameters["access_token"];
      if (accessToken == null) {
        return const Left(AuthFailure("The state token did not match. Please try again."));
      }
      return Right(accessToken);
    });
  }

  String _generateStateToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(21, (i) => random.nextInt(256));
    return base64Url.encode(bytes);
  }
}
