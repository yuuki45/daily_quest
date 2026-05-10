import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tri_task/widgets/pixel_button.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('label を表示する', (tester) async {
    await tester.pumpWidget(wrap(
      PixelButton(label: '冒険を始める', onPressed: () {}),
    ));
    expect(find.text('冒険を始める'), findsOneWidget);
  });

  testWidgets('onPressed が呼ばれる', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(wrap(
      PixelButton(label: 'tap', onPressed: () => tapped++),
    ));
    await tester.tap(find.text('tap'));
    expect(tapped, 1);
  });

  testWidgets('onPressed が null だとタップしても呼ばれない', (tester) async {
    await tester.pumpWidget(wrap(
      const PixelButton(label: 'disabled', onPressed: null),
    ));
    await tester.tap(find.text('disabled'));
    // 例外なく完了することを確認
    expect(tester.takeException(), isNull);
  });

  testWidgets('icon が指定された場合に表示される', (tester) async {
    await tester.pumpWidget(wrap(
      PixelButton(
        label: 'add',
        icon: Icons.add,
        onPressed: () {},
      ),
    ));
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
