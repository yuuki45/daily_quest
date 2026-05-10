import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_task/widgets/exp_bar.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('現/最大EXPを表示する', (tester) async {
    await tester.pumpWidget(wrap(
      const ExpBar(currentExp: 70, maxExp: 100),
    ));
    expect(find.text('EXP'), findsOneWidget);
    expect(find.text('70 / 100'), findsOneWidget);
  });

  testWidgets('showLabel:false でラベル非表示', (tester) async {
    await tester.pumpWidget(wrap(
      const ExpBar(currentExp: 70, maxExp: 100, showLabel: false),
    ));
    expect(find.text('EXP'), findsNothing);
  });

  testWidgets('maxExp が 0 でも例外にならない', (tester) async {
    await tester.pumpWidget(wrap(
      const ExpBar(currentExp: 0, maxExp: 0),
    ));
    expect(tester.takeException(), isNull);
  });
}
