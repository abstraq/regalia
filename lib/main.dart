import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/core/presentation/colors.dart";
import "package:regalia/core/presentation/text_styles.dart";
import "package:regalia/routing/router.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryMainColor,
          onPrimary: Colors.white,
          secondary: AppColors.primaryLighter,
          onSecondary: Colors.white,
          tertiary: AppColors.primarySubtle,
          onTertiary: Colors.white,
          background: AppColors.darkDark0,
          surface: AppColors.darkDark1,
          error: AppColors.redRed1,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.displayDisplay1,
          displayMedium: AppTextStyles.displayDisplay2,
          headlineLarge: AppTextStyles.headingsH1,
          headlineMedium: AppTextStyles.headingsH2,
          headlineSmall: AppTextStyles.headingsH3,
          titleLarge: AppTextStyles.headingsH4,
          titleMedium: AppTextStyles.headingsH5,
          titleSmall: AppTextStyles.headingsH6,
          bodySmall: AppTextStyles.smallLabel,
          bodyMedium: AppTextStyles.mediumLabel,
          bodyLarge: AppTextStyles.largeLabel,
        ),
        useMaterial3: true,
      ),
    );
  }
}
