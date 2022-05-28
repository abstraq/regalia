import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/presentation/splash_screen.dart";
import "package:regalia/features/authentication/application/credential_service.dart";
import "package:regalia/features/authentication/presentation/auth_screen.dart";
import "package:regalia/features/home/presentation/home_screen.dart";

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
      GoRoute(path: "/channels/:id", name: "channel", builder: (context, state) => const HomeScreen()),
    ],
    redirect: (routerState) {
      return ref.read(credentialServiceProvider).whenOrNull<String?>(
        data: (credentials) {
          // If the user is authenticated but still at auth or splash, redirect to the home screen.
          if (credentials != null && ["/auth", "/splash"].contains(routerState.subloc)) {
            return "/";
          }
          // If the user is not authenticated but not at auth, redirect to the auth screen.
          if (credentials == null && routerState.subloc != "/auth") {
            return "/auth";
          }
          return null;
        },
      );
    },
  );
});
