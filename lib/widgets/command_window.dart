import 'package:flutter/material.dart';
import 'package:tri_task/core/theme/app_colors.dart';
import 'package:tri_task/core/theme/app_theme.dart';

/// JRPGコマンドウィンドウ風のカード。
/// ダークネイビー背景 + 太い金枠 + 角丸なし。中のテキストは cream をデフォルト色に。
class CommandWindow extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CommandWindow({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppTheme.spacingMd),
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 3.0,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final body = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.windowBg,
        border: Border.all(
          color: borderColor ?? AppColors.gold,
          width: borderWidth,
        ),
        // 角丸なし — ピュアなピクセル感
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: AppColors.cream),
        child: IconTheme.merge(
          data: const IconThemeData(color: AppColors.cream),
          child: child,
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
                child: body,
              ),
            )
          : body,
    );
  }
}
