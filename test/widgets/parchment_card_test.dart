import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_task/widgets/parchment_card.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('child を表示する', (tester) async {
    await tester.pumpWidget(wrap(
      const ParchmentCard(child: Text('hello')),
    ));
    expect(find.text('hello'), findsOneWidget);
  });

  testWidgets('onTap が呼ばれる', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(wrap(
      ParchmentCard(
        onTap: () => tapped++,
        child: const Text('tap me'),
      ),
    ));
    await tester.tap(find.text('tap me'));
    expect(tapped, 1);
  });
}
