import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tri_task/constants/app_constants.dart';
import 'package:tri_task/constants/app_theme.dart';
import 'package:tri_task/providers/daily_plan_provider.dart';
import 'package:tri_task/providers/task_provider.dart';
import 'package:tri_task/widgets/task_card.dart';

class PlanEditorSheet extends ConsumerStatefulWidget {
  const PlanEditorSheet({super.key});

  @override
  ConsumerState<PlanEditorSheet> createState() => _PlanEditorSheetState();
}

class _PlanEditorSheetState extends ConsumerState<PlanEditorSheet> {
  final TextEditingController _newTaskController = TextEditingController();
  String? _selectedTag;
  bool _isMainTask = true; // true: メインタスク, false: サブタスク
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    // メインタスクがあるかチェック
    final plan = ref.read(dailyPlanNotifierProvider);
    if (plan.mainTaskId != null) {
      _isMainTask = false; // メインタスクがある場合はサブタスクモードに
    }

    // テキスト変更を監視
    _newTaskController.addListener(() {
      final hasText = _newTaskController.text.trim().isNotEmpty;
      if (_hasText != hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _newTaskController.dispose();
    super.dispose();
  }

  Future<void> _addNewTask() async {
    if (_newTaskController.text.trim().isEmpty) return;

    // 軽い振動フィードバック
    HapticFeedback.lightImpact();

    final plan = ref.read(dailyPlanNotifierProvider);

    // メインタスクの場合
    if (_isMainTask) {
      if (plan.mainTaskId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('メインタスクは既に設定されています'),
            backgroundColor: AppTheme.accentColor,
          ),
        );
        return;
      }
    } else {
      // サブタスクの場合
      if (plan.subTaskIds.length >= AppConstants.maxSubTasks) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('サブタスクは最大${AppConstants.maxSubTasks}つまでです'),
            backgroundColor: AppTheme.accentColor,
          ),
        );
        return;
      }
    }

    // タスクを追加
    final taskTitle = _newTaskController.text.trim();
    final isMain = _isMainTask;

    final newTaskId = await ref.read(taskNotifierProvider.notifier).addTask(
          title: taskTitle,
          tag: _selectedTag,
        );

    // 今日のプランに追加
    if (isMain) {
      await ref.read(dailyPlanNotifierProvider.notifier).setMainTask(newTaskId);
    } else {
      await ref.read(dailyPlanNotifierProvider.notifier).addSubTask(newTaskId);
    }

    _newTaskController.clear();
    setState(() {
      _selectedTag = null;
      // メインタスク追加後は自動的にサブタスクモードに
      if (_isMainTask) {
        _isMainTask = false;
      }
    });

    // タスクを追加したらシートを閉じる
    if (mounted) {
      Navigator.pop(context);

      // 成功フィードバック
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('${isMain ? "メイン" : "サブ"}タスクを追加しました'),
            ],
          ),
          backgroundColor: AppTheme.primaryColor,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.borderRadius),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLarge,
              vertical: AppTheme.spacing,
            ),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.borderRadius),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.textSecondary.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'タスクを追加',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppTheme.textSecondary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Task type selector
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLarge,
              vertical: AppTheme.spacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'タスクの種類',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    // サブタスクの残り枠表示
                    if (!_isMainTask)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'あと${AppConstants.maxSubTasks - ref.watch(dailyPlanNotifierProvider).subTaskIds.length}つ追加可能',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Text('メインタスク'),
                        selected: _isMainTask,
                        onSelected: ref.watch(dailyPlanNotifierProvider).mainTaskId == null
                            ? (selected) {
                                setState(() {
                                  _isMainTask = true;
                                });
                              }
                            : null,
                        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        backgroundColor: AppTheme.cardColor,
                        disabledColor: AppTheme.textSecondary.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: _isMainTask ? AppTheme.primaryColor : AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: _isMainTask ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    Expanded(
                      child: ChoiceChip(
                        label: Text('サブタスク'),
                        selected: !_isMainTask,
                        onSelected: (selected) {
                          setState(() {
                            _isMainTask = false;
                          });
                        },
                        selectedColor: AppTheme.secondaryColor.withOpacity(0.2),
                        backgroundColor: AppTheme.cardColor,
                        labelStyle: TextStyle(
                          color: !_isMainTask ? AppTheme.secondaryColor : AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: !_isMainTask ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                // 説明テキスト
                if (ref.watch(dailyPlanNotifierProvider).mainTaskId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppTheme.spacingSmall),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: AppTheme.textSecondary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'メインタスクは1日1つまでです',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary.withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // New task input
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppTheme.spacingLarge,
                right: AppTheme.spacingLarge,
                bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spacing,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppTheme.spacing),
                  // タスク名入力セクション
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                      border: Border.all(
                        color: AppTheme.textSecondary.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'タスク名',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        TextField(
                          controller: _newTaskController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'タスク名を入力',
                            hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.6)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                              borderSide: BorderSide(color: AppTheme.textSecondary.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                              borderSide: BorderSide(color: AppTheme.textSecondary.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacing,
                              vertical: 16,
                            ),
                            filled: true,
                            fillColor: AppTheme.backgroundColor,
                          ),
                          onSubmitted: (_) {
                            // キーボードを閉じるだけ
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                  // Tag selector
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'カテゴリー（任意）',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSmall),
                  Wrap(
                    spacing: AppTheme.spacingSmall,
                    runSpacing: AppTheme.spacingSmall,
                    children: AppConstants.availableTags.map((tag) {
                      final isSelected = _selectedTag == tag;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _selectedTag = isSelected ? null : tag;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.textSecondary.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppTheme.spacingLarge),
                  // Add button
                  AnimatedScale(
                    scale: _hasText ? 1.0 : 0.95,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: AnimatedOpacity(
                      opacity: _hasText ? 1.0 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _hasText ? _addNewTask : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppTheme.textSecondary.withOpacity(0.3),
                            disabledForegroundColor: AppTheme.textSecondary.withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                            ),
                            elevation: _hasText ? 2 : 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '追加',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
