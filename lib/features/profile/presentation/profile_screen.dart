import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hciiii/core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.push('/accessibility'),
                icon: const Icon(Icons.tune),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.snapSurfaceRaised,
            child: Icon(Icons.person, size: 48),
          ),
          const SizedBox(height: 12),
          Text(
            'snap.user',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Snapscore 24,580',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.snapMuted,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _QuickAction(
                  icon: Icons.group_add,
                  label: 'Add Friends',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickAction(
                  icon: Icons.public,
                  label: 'Public Profile',
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.accessibility_new),
              title: const Text('Accessibility settings'),
              subtitle: const Text('High contrast, larger text, reduced motion'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/accessibility'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App info'),
              subtitle: const Text('Version 1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.snapSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.snapBorder),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
