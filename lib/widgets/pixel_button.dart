import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_text_styles.dart';
import 'package:tri_task/core/theme/app_theme.dart';

enum PixelButtonVariant { primary, secondary, danger }

/// モダンスタイリッシュなアクションボタン。
/// (旧称 PixelButton, 互換のため名前は残す)
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
        return AppColors.accent;
      case PixelButtonVariant.secondary:
        return AppColors.accentYellow;
      case PixelButtonVariant.danger:
        return AppColors.accentRed;
    }
  }

  Color get _foregroundColor {
    switch (variant) {
      case PixelButtonVariant.primary:
      case PixelButtonVariant.secondary:
        return AppColors.textOnAccent;
      case PixelButtonVariant.danger:
        return AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final radius = BorderRadius.circular(8);

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
              boxShadow: disabled
                  ? null
                  : [
                      BoxShadow(
                        color: _backgroundColor.withValues(alpha: 0.45),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
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
