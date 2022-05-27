import "dart:convert";
import "dart:math";

import "package:flutter_inappwebview/flutter_inappwebview.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/domain/exceptions/auth_exception.dart";
import "package:uni_links/uni_links.dart";

/// Data source for authenticating with twitch through the user's
/// browser.
class TwitchAuthBrowserDataSource {
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

  Future<String> authorize() async {
    final browser = ChromeSafariBrowser();
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
    await browser.open(
      url: authorizationUrl,
      options: ChromeSafariBrowserClassOptions(
        android: AndroidChromeCustomTabsOptions(noHistory: true, shareState: CustomTabsShareState.SHARE_STATE_OFF),
      ),
    );

    // Wait for the first deep link to me.abstraq.regalia://oauth2 then close the browser.
    final link = await uriLinkStream.firstWhere((url) {
      return url?.scheme == "me.abstraq.regalia" && url?.host == "oauth2";
    });

    await browser.close();

    // There was an error when receiving the deep link.
    if (link == null) {
      throw AuthException("There was an error while authenticating. Please try again");
    }

    // Check if the deep link contained an error.
    if (link.queryParameters.containsKey("error")) {
      if (link.queryParameters["state"] != stateToken) {
        throw AuthException("The state token did not match. Please try again.");
      }
      throw AuthException("You did not authorize the app.");
    }

    // Parse the deep link and return the access token.
    final fragmentParameters = Uri.splitQueryString(link.fragment);

    // Check if the state token is valid.
    if (fragmentParameters["state"] != stateToken) {
      throw AuthException("The state token did not match. Please try again.");
    }

    final accessToken = fragmentParameters["access_token"];
    if (accessToken == null) {
      throw AuthException("The state token did not match. Please try again.");
    }

    return accessToken;
  }

  String _generateStateToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(21, (i) => random.nextInt(256));
    return base64Url.encode(bytes);
  }
}

final twitchAuthBrowserDataSourceProvider =
    Provider.autoDispose<TwitchAuthBrowserDataSource>((_) => TwitchAuthBrowserDataSource());
