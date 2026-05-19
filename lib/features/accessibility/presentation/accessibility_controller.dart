import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccessibilitySettings {
  const AccessibilitySettings({
    this.highContrast = false,
    this.largeText = false,
    this.largerTouchTargets = true,
    this.reduceMotion = false,
  });

  final bool highContrast;
  final bool largeText;
  final bool largerTouchTargets;
  final bool reduceMotion;

  AccessibilitySettings copyWith({
    bool? highContrast,
    bool? largeText,
    bool? largerTouchTargets,
    bool? reduceMotion,
  }) {
    return AccessibilitySettings(
      highContrast: highContrast ?? this.highContrast,
      largeText: largeText ?? this.largeText,
      largerTouchTargets: largerTouchTargets ?? this.largerTouchTargets,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }
}

class AccessibilitySettingsController
    extends StateNotifier<AccessibilitySettings> {
  AccessibilitySettingsController() : super(const AccessibilitySettings());

  void toggleHighContrast(bool value) {
    state = state.copyWith(highContrast: value);
  }

  void toggleLargeText(bool value) {
    state = state.copyWith(largeText: value);
  }

  void toggleTouchTargets(bool value) {
    state = state.copyWith(largerTouchTargets: value);
  }

  void toggleReduceMotion(bool value) {
    state = state.copyWith(reduceMotion: value);
  }
}

final accessibilitySettingsProvider =
    StateNotifierProvider<AccessibilitySettingsController, AccessibilitySettings>(
  (ref) => AccessibilitySettingsController(),
);
