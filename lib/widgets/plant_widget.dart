import 'package:flutter/material.dart';
import 'package:tri_task/constants/app_theme.dart';

class PlantWidget extends StatelessWidget {
  final String emoji;
  final int streakCount;

  const PlantWidget({
    required this.emoji,
    required this.streakCount,
    super.key,
  });

  String _getStatusMessage(int count) {
    if (count == 0) return 'さあ、はじめよう！';
    if (count >= 30) return 'きょうは満開！よくできました';
    if (count >= 14) return '花が咲きました！素晴らしい';
    if (count >= 7) return 'つぼみができました！順調です';
    if (count >= 3) return '芽が育っています！いい調子';
    return 'よく頑張りました！';
  }

  String _getGrowthStatus(int count) {
    if (count == 0) return '種を植えよう';
    if (count >= 30) return '満開の花';
    if (count >= 14) return '美しい花';
    if (count >= 7) return 'つぼみ育成中';
    if (count >= 3) return '芽が育ち中';
    return '新芽が出たよ';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardColor,
            AppTheme.primaryColor.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ビジュアル層：植物絵文字
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 64),
            ),
          ),
          const SizedBox(height: 12),
          // メッセージ層：タイトル
          Text(
            _getStatusMessage(streakCount),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          // サマリー層：連続日数と状態
          Text(
            '連続 $streakCount 日・${_getGrowthStatus(streakCount)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E2430).withOpacity(0.7),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // 進捗バー層：30日設計
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // プログレスバー
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 8,
                  child: LinearProgressIndicator(
                    value: (streakCount / 30).clamp(0.0, 1.0),
                    backgroundColor: const Color(0xFF1E2430).withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              // 進捗テキスト
              Text(
                '目標まで ${(30 - streakCount).clamp(0, 30)} 日',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E2430).withOpacity(0.5),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
