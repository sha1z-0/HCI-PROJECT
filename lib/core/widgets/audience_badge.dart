import 'package:flutter/material.dart';
import 'package:hciiii/core/constants/app_colors.dart';

class AudienceBadge extends StatelessWidget {
  const AudienceBadge({
    super.key,
    required this.label,
    this.isHighContrast = false,
  });

  final String label;
  final bool isHighContrast;

  @override
  Widget build(BuildContext context) {
    final Color background = isHighContrast
        ? AppColors.highContrastYellow
        : AppColors.snapYellow;
    final Color foreground = isHighContrast
        ? AppColors.highContrastBlack
        : AppColors.snapBlack;

    return Semantics(
      label: 'Audience: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: foreground.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: background.withOpacity(0.3),
              blurRadius: 12,
            ),
          ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
        ),
      ),
    );
  }
}
