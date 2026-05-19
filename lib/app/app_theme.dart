import 'package:flutter/material.dart';
import 'package:hciiii/core/constants/app_colors.dart';
import 'package:hciiii/features/accessibility/presentation/accessibility_controller.dart';

class AppTheme {
  static ThemeData light(AccessibilitySettings settings) {
    return _baseTheme(
      brightness: Brightness.light,
      settings: settings,
      colorScheme: _lightScheme,
    );
  }

  static ThemeData dark(AccessibilitySettings settings) {
    return _baseTheme(
      brightness: Brightness.dark,
      settings: settings,
      colorScheme: _darkScheme,
    );
  }

  static ThemeData highContrast(AccessibilitySettings settings) {
    return _baseTheme(
      brightness: Brightness.dark,
      settings: settings,
      colorScheme: _highContrastScheme,
    );
  }

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.snapYellow,
    onPrimary: AppColors.snapBlack,
    secondary: AppColors.accentBlue,
    onSecondary: Colors.white,
    error: AppColors.accentRed,
    onError: Colors.white,
    surface: AppColors.snapWhite,
    onSurface: AppColors.snapBlack,
    background: Colors.white,
    onBackground: AppColors.snapBlack,
    outline: AppColors.snapBorder,
    outlineVariant: AppColors.snapBorder,
    shadow: Colors.black26,
    scrim: Colors.black45,
    surfaceTint: AppColors.snapYellow,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.snapYellow,
    onPrimary: AppColors.snapBlack,
    secondary: AppColors.accentBlue,
    onSecondary: AppColors.snapBlack,
    error: AppColors.accentRed,
    onError: Colors.white,
    surface: AppColors.snapSurface,
    onSurface: AppColors.snapWhite,
    background: AppColors.snapBlack,
    onBackground: AppColors.snapWhite,
    outline: AppColors.snapBorder,
    outlineVariant: AppColors.snapBorder,
    shadow: Colors.black87,
    scrim: Colors.black54,
    surfaceTint: AppColors.snapYellow,
  );

  static const ColorScheme _highContrastScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.highContrastYellow,
    onPrimary: AppColors.highContrastBlack,
    secondary: AppColors.accentBlue,
    onSecondary: AppColors.highContrastBlack,
    error: AppColors.accentRed,
    onError: Colors.white,
    surface: AppColors.highContrastBlack,
    onSurface: AppColors.highContrastWhite,
    background: AppColors.highContrastBlack,
    onBackground: AppColors.highContrastWhite,
    outline: AppColors.highContrastWhite,
    outlineVariant: AppColors.highContrastWhite,
    shadow: Colors.black87,
    scrim: Colors.black54,
    surfaceTint: AppColors.highContrastYellow,
  );

  static ThemeData _baseTheme({
    required Brightness brightness,
    required AccessibilitySettings settings,
    required ColorScheme colorScheme,
  }) {
    final baseTextTheme = ThemeData(brightness: brightness).textTheme;
    final textTheme = baseTextTheme.apply(
      fontFamily: 'Lexend',
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    final refinedTextTheme = textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      displayMedium: textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelLarge: textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: 'Lexend',
      textTheme: refinedTextTheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: refinedTextTheme.titleLarge?.copyWith(
          color: colorScheme.onBackground,
        ),
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        elevation: settings.highContrast ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: colorScheme.outline.withOpacity(0.6),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: settings.highContrast ? 1.4 : 0.8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: refinedTextTheme.bodyMedium?.copyWith(
          color: AppColors.snapMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: refinedTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: BorderSide(color: colorScheme.outline),
          textStyle: refinedTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: refinedTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary.withOpacity(0.2),
        labelStyle: refinedTextTheme.labelLarge,
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surface,
        contentTextStyle: refinedTextTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurface,
        textColor: colorScheme.onSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      materialTapTargetSize: settings.largerTouchTargets
          ? MaterialTapTargetSize.padded
          : MaterialTapTargetSize.shrinkWrap,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: settings.reduceMotion
            ? const {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
              }
            : const {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
      ),
    );
  }
}
