import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_theme.dart';

/// モダンなダークカード。左に細いアクセント帯、軽いシャドウ、控えめな角丸。
class SlabCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? accentColor;
  final double accentWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SlabCard({
    required this.child,
    super.key,
    this.backgroundColor,
    this.accentColor,
    this.accentWidth = 4.0,
    this.padding = const EdgeInsets.all(AppTheme.spacingLg),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 10.0,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    final body = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (accentColor != null)
              Container(width: accentWidth, color: accentColor),
            Expanded(
              child: Padding(
                padding: padding,
                child: DefaultTextStyle.merge(
                  style: const TextStyle(color: AppColors.textPrimary),
                  child: IconTheme.merge(
                    data: const IconThemeData(color: AppColors.textPrimary),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final interactive = onTap != null || onLongPress != null;
    return Padding(
      padding: margin,
      child: interactive
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                borderRadius: radius,
                child: body,
              ),
            )
          : body,
    );
  }
}
