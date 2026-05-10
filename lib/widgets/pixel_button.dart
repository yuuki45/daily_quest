import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';

enum PixelButtonVariant { primary, secondary, danger }

/// レトロRPG風ボタン。ハードシャドウで「凸面」感を出す。
class PixelButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PixelButtonVariant variant;
  final bool fullWidth;

  const PixelButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.variant = PixelButtonVariant.primary,
    this.fullWidth = false,
  });

  Color get _backgroundColor {
    switch (variant) {
      case PixelButtonVariant.primary:
        return AppColors.blue;
      case PixelButtonVariant.secondary:
        return AppColors.gold;
      case PixelButtonVariant.danger:
        return AppColors.crimson;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case PixelButtonVariant.primary:
      case PixelButtonVariant.danger:
        return AppColors.cream;
      case PixelButtonVariant.secondary:
        return AppColors.brown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final radius = BorderRadius.circular(AppTheme.radiusMedium);

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: Container(
            constraints: BoxConstraints(
              minHeight: AppTheme.minTapSize,
              minWidth: fullWidth ? double.infinity : 0,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacingSm,
            ),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: radius,
              border: Border.all(
                color: AppColors.border,
                width: AppTheme.borderWidth,
              ),
              boxShadow: disabled
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.brown.withValues(alpha: 0.35),
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: _foregroundColor),
                  const SizedBox(width: AppTheme.spacingSm),
                ],
                Text(
                  label,
                  style: AppTextStyles.button.copyWith(color: _foregroundColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
