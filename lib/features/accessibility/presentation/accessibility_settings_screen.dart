import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hciiii/features/accessibility/presentation/accessibility_controller.dart';

class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilitySettingsProvider);
    final controller = ref.read(accessibilitySettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: settings.highContrast,
            onChanged: controller.toggleHighContrast,
            title: const Text('High contrast mode'),
            subtitle: const Text('Stronger contrast for readability.'),
          ),
          SwitchListTile(
            value: settings.largeText,
            onChanged: controller.toggleLargeText,
            title: const Text('Large text mode'),
            subtitle: const Text('Increase text size across the app.'),
          ),
          SwitchListTile(
            value: settings.largerTouchTargets,
            onChanged: controller.toggleTouchTargets,
            title: const Text('Larger touch targets'),
            subtitle: const Text('Bigger tap areas for controls.'),
          ),
          SwitchListTile(
            value: settings.reduceMotion,
            onChanged: controller.toggleReduceMotion,
            title: const Text('Reduce motion'),
            subtitle: const Text('Minimize animations and transitions.'),
          ),
          const SizedBox(height: 16),
          Text(
            'Screen reader support is enabled for key controls, stories, and reels.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
