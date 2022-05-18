import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../core/presentation/screens/home_screen.dart";
import "../core/presentation/screens/splash_screen.dart";
import "../features/authentication/application/credential_service.dart";
import "../features/authentication/presentation/auth_screen.dart";

final routerProvider = Provider<GoRouter>((ref) {
  final refreshStream = GoRouterRefreshStream(ref.watch(credentialServiceProvider.notifier).stream);
  ref.onDispose(refreshStream.dispose);

  return GoRouter(
    refreshListenable: refreshStream,
    initialLocation: "/splash",
    routes: [
      GoRoute(path: "/", name: "home", builder: (context, state) => const HomeScreen()),
      GoRoute(path: "/auth", name: "auth", builder: (context, state) => const AuthScreen()),
      GoRoute(path: "/splash", name: "splash", builder: (context, state) => const SplashScreen()),
    ],
    redirect: (routerState) {
      return ref.read(credentialServiceProvider).whenOrNull<String?>(
        data: (credentialsOption) {
          return credentialsOption.match(
            // If the user is authenticated but still at auth or splash, redirect to the home screen.
            (_) => ["/auth", "/splash"].contains(routerState.subloc) ? "/" : null,
            // If the user is not authenticated but not at auth, redirect to the auth screen.
            () => routerState.subloc != "/auth" ? "/auth" : null,
          );
        },
      );
    },
  );
});
