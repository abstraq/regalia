import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../core/presentation/screens/home_screen.dart";
import "../core/presentation/screens/splash_screen.dart";
import "../features/authentication/application/auth_notifier.dart";
import "../features/authentication/presentation/auth_screen.dart";

final routerProvider = Provider<GoRouter>((ref) {
  final refreshStream = GoRouterRefreshStream(ref.watch(authNotifierProvider.notifier).stream);
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
      return ref.read(authNotifierProvider).whenOrNull<String?>(
            // User is unauthenticated but not at auth screen, redirect them to auth screen.
            unauthenticated: () => routerState.subloc != "/auth" ? "/auth" : null,
            // User is authenticated but still at auth screen or splash screen, redirect them to home.
            authenticated: (_) => ["/auth", "/splash"].contains(routerState.subloc) ? "/" : null,
          );
    },
  );
});
