import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/presentation/default_theme.dart";
import "package:regalia/routing/router.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString("fonts/OFL.txt");
    yield LicenseEntryWithLineBreaks(["lato"], license);
  });
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
      theme: DefaultTheme.darkTheme,
    );
  }
}
