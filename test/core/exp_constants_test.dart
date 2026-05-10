import 'package:flutter_test/flutter_test.dart';
import 'package:tri_task/core/constants/exp_constants.dart';

void main() {
  group('ExpConstants', () {
    test('1日最大EXPは120 (50+20+20+30)', () {
      expect(ExpConstants.dailyMaxExp, 120);
    });

    group('levelFromTotalExp', () {
      test('0 EXP → Lv.1', () {
        expect(ExpConstants.levelFromTotalExp(0), 1);
      });

      test('99 EXP → Lv.1（境界手前）', () {
        expect(ExpConstants.levelFromTotalExp(99), 1);
      });

      test('100 EXP → Lv.2（境界）', () {
        expect(ExpConstants.levelFromTotalExp(100), 2);
      });

      test('101 EXP → Lv.2（境界超え）', () {
        expect(ExpConstants.levelFromTotalExp(101), 2);
      });

      test('500 EXP → Lv.6', () {
        expect(ExpConstants.levelFromTotalExp(500), 6);
      });
    });

    group('currentLevelExp', () {
      test('0 EXP → 0', () {
        expect(ExpConstants.currentLevelExp(0), 0);
      });

      test('100 EXP → 0（次レベルの開始）', () {
        expect(ExpConstants.currentLevelExp(100), 0);
      });

      test('150 EXP → 50', () {
        expect(ExpConstants.currentLevelExp(150), 50);
      });

      test('250 EXP → 50（Lv.3の中程）', () {
        expect(ExpConstants.currentLevelExp(250), 50);
      });
    });
  });
}
