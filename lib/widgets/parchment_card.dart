import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_theme.dart';

/// 羊皮紙風カードの基底Widget。
/// クリーム背景 + 茶色枠線 + 角丸 で「冒険手帳のページ」感を出す。
class ParchmentCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ParchmentCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppTheme.spacingMd),
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppTheme.radiusMedium;
    final br = BorderRadius.circular(radius);

    final body = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cream,
        borderRadius: br,
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: borderWidth ?? AppTheme.borderWidth,
        ),
      ),
      child: child,
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
                borderRadius: br,
                child: body,
              ),
            )
          : body,
    );
  }
}
