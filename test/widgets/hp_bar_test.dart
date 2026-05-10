import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_task/widgets/hp_bar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('HPラベルと数値を表示する', (tester) async {
    await tester.pumpWidget(wrap(
      const HpBar(currentHp: 5, maxHp: 7),
    ));
    expect(find.text('HP'), findsOneWidget);
    expect(find.text('5 / 7'), findsOneWidget);
  });

  testWidgets('label を差し替えられる', (tester) async {
    await tester.pumpWidget(wrap(
      const HpBar(currentHp: 3, maxHp: 7, label: 'ボスHP'),
    ));
    expect(find.text('ボスHP'), findsOneWidget);
  });
}
