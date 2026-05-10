import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tri_task/core/theme/app_theme.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  // 注: QuestScreen を含む統合的な widget test は、google_fonts や
  // Hive の Future がフェイクタイマー内で resolve せず10分タイムアウトする
  // 既知問題により未実装。Step 8 の手動QAでカバー。
  // 代わりにテーマが構築されること、最小Widget Treeでpump可能なことを確認する。
  testWidgets('AppTheme.light builds and renders a minimal app', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: Center(child: Text('Daily Quest'))),
      ),
    );
    expect(find.text('Daily Quest'), findsOneWidget);
  });
}
