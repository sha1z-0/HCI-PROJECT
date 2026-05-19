import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hciiii/app/app_router.dart';
import 'package:hciiii/app/app_theme.dart';
import 'package:hciiii/features/accessibility/presentation/accessibility_controller.dart';

class HciiiiApp extends ConsumerWidget {
  const HciiiiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);
    final router = ref.watch(appRouterProvider);

    final ThemeData lightTheme = settings.highContrast
        ? AppTheme.highContrast(settings)
        : AppTheme.light(settings);

    final ThemeData darkTheme = settings.highContrast
        ? AppTheme.highContrast(settings)
        : AppTheme.dark(settings);

    return MaterialApp.router(
      title: 'HCI Snap',
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final double textScale = settings.largeText ? 1.2 : 1.0;
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: settings.reduceMotion,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
