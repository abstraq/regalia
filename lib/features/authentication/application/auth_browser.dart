import "dart:async";
import "dart:developer" as developer;

import "package:flutter_inappwebview/flutter_inappwebview.dart";
import "package:regalia/features/authentication/domain/exceptions/auth_exception.dart";
import "package:uni_links/uni_links.dart";

class AuthBrowser extends ChromeSafariBrowser {
  final Completer<String> _completer = Completer();
  final String _stateToken;

  StreamSubscription? _subscription;

  AuthBrowser({required String stateToken}) : _stateToken = stateToken;

  Future<String> accessToken() => _completer.future;

  @override
  void onOpened() {
    developer.log(name: "AuthBrowser", "Opened auth browser.");
    _subscription = uriLinkStream.listen((link) {
      if (link != null && link.scheme == "rglia") {
        _handle(link);
      }
    });
  }

  @override
  void onClosed() {
    _subscription?.cancel();
    _subscription = null;
    if (!_completer.isCompleted) {
      _completer.completeError(AuthException("You cancelled authentication."));
      return;
    }
    developer.log(name: "AuthBrowser", "Closed auth browser.");
  }

  void _handle(final Uri link) {
    // Close the browser if it is still open.
    if (isOpened()) {
      close();
    }

    // Check if the link contains an error.
    if (link.queryParameters.containsKey("error")) {
      if (link.queryParameters["state"] != _stateToken) {
        _completer.completeError(AuthException("The state token did not match. Please try again."));
        return;
      }

      _completer.completeError(AuthException("You did not authorize the app."));
      return;
    }

    final fragmentParameters = Uri.splitQueryString(link.fragment);

    // Check if the state token is valid.
    if (fragmentParameters["state"] != _stateToken) {
      _completer.completeError(AuthException("The state token did not match. Please try again."));
      return;
    }

    // Get the deep link from the fragment.
    final accessToken = fragmentParameters["access_token"];
    if (accessToken == null) {
      _completer.completeError(AuthException("The access token was not found."));
      return;
    }
    _completer.complete(accessToken);
  }
}
