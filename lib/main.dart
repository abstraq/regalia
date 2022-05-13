import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "src/routing/router.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: RegaliaApp()));
}

/// Root widget for the application.
class RegaliaApp extends ConsumerWidget {
  const RegaliaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: "Regalia",
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF32142D),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
    );
  }
}
