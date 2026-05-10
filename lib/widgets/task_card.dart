import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tri_task/constants/app_theme.dart';
import 'package:tri_task/models/task.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onLongPress;
  final bool showCheckbox;

  const TaskCard({
    required this.task,
    this.onTap,
    this.onToggle,
    this.onLongPress,
    this.showCheckbox = true,
    super.key,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleToggle() {
    // 軽い振動フィードバック
    HapticFeedback.lightImpact();
    _animationController.forward(from: 0);
    widget.onToggle?.call();
  }

  Color _getTagColor(String? tag) {
    switch (tag) {
      case '仕事':
        return const Color(0xFF5B8CFF);
      case '生活':
        return const Color(0xFF66BB6A);
      case '勉強':
        return const Color(0xFFFF9B9B);
      case '健康':
        return const Color(0xFFEC407A);
      case 'その他':
        return const Color(0xFF9094A6);
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress != null
          ? () async {
              // まず視覚効果を表示
              setState(() => _isPressed = true);
              HapticFeedback.mediumImpact();

              // 200ms待ってからメニューを表示（視覚効果を見せるため）
              await Future.delayed(const Duration(milliseconds: 200));

              if (mounted) {
                setState(() => _isPressed = false);
                widget.onLongPress?.call();
              }
            }
          : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: AppTheme.spacing),
          padding: const EdgeInsets.all(AppTheme.spacing),
          decoration: BoxDecoration(
            color: _isPressed
                ? AppTheme.primaryColor.withOpacity(0.15)
                : AppTheme.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            border: _isPressed
                ? Border.all(color: AppTheme.primaryColor, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: _isPressed
                    ? AppTheme.primaryColor.withOpacity(0.4)
                    : AppTheme.shadowColor,
                blurRadius: _isPressed ? 16 : 8,
                offset: Offset(0, _isPressed ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            children: [
            if (widget.showCheckbox)
              ScaleTransition(
                scale: _scaleAnimation,
                child: GestureDetector(
                  onTap: _handleToggle,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.task.done
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                        width: 2,
                      ),
                      color: widget.task.done ? AppTheme.primaryColor : Colors.transparent,
                    ),
                    child: widget.task.done
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
            if (widget.showCheckbox) const SizedBox(width: AppTheme.spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          decoration: widget.task.done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: widget.task.done
                              ? AppTheme.textSecondary
                              : AppTheme.textPrimary,
                        ),
                  ),
                  if (widget.task.tag != null) ...[
                    const SizedBox(height: AppTheme.spacingSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTagColor(widget.task.tag).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.task.tag!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getTagColor(widget.task.tag),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
