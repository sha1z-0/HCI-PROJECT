import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hciiii/core/constants/app_colors.dart';
import 'package:hciiii/features/shared/providers/navigation_index_provider.dart';

class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, WidgetRef ref, int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
    ref.read(navigationIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = navigationShell.currentIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final indexNotifier = ref.read(navigationIndexProvider.notifier);
      if (indexNotifier.state != currentIndex) {
        indexNotifier.state = currentIndex;
      }
    });

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.snapBlack,
            border: Border(
              top: BorderSide(color: AppColors.snapBorder),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavIcon(
                icon: Icons.chat_bubble,
                label: 'Chat',
                isActive: currentIndex == 0,
                onTap: () => _onTap(context, ref, 0),
              ),
              _NavIcon(
                icon: Icons.collections,
                label: 'Stories',
                isActive: currentIndex == 1,
                onTap: () => _onTap(context, ref, 1),
              ),
              _CameraButton(
                isActive: currentIndex == 2,
                onTap: () => _onTap(context, ref, 2),
              ),
              _NavIcon(
                icon: Icons.video_collection,
                label: 'Reels',
                isActive: currentIndex == 3,
                onTap: () => _onTap(context, ref, 3),
              ),
              _NavIcon(
                icon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 4,
                onTap: () => _onTap(context, ref, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.snapYellow.withOpacity(0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            size: 22,
            color: isActive ? AppColors.snapYellow : AppColors.snapWhite,
          ),
        ),
      ),
    );
  }
}

class _CameraButton extends StatelessWidget {
  const _CameraButton({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.snapYellow,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.snapYellow.withOpacity(0.4),
              blurRadius: isActive ? 16 : 10,
              spreadRadius: isActive ? 2 : 0,
            ),
          ],
        ),
        child: Icon(
          Icons.camera_alt,
          color: AppColors.snapBlack,
          size: 24,
        ),
      ),
    );
  }
}
