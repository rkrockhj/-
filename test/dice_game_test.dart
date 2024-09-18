import 'package:flutter_test/flutter_test.dart';
import '../lib/dice_game.dart';

void main() {
  group('determineRankLogic 测试', () {
    test('红六勃 - 状元', () {
      List<int> diceValues = [4, 4, 4, 4, 4, 4];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '红六勃 - 状元');
    });

    test('遍地锦 - 状元', () {
      List<int> diceValues = [1, 1, 1, 1, 1, 1];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '遍地锦 - 状元');
    });

    test('黑六勃 - 状元', () {
      // List<int> diceValues = [2, 2, 2, 2, 2, 2];

      // List<int> diceValues = [3, 3, 3, 3, 3, 3];
      // List<int> diceValues = [6, 6, 6, 6, 6, 6];
      //5
      List<int> diceValues = [5, 5, 5, 5, 5, 5];

      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '黑六勃 - 状元');
    });

    test('插金花 - 状元', () {
      List<int> diceValues = [4, 4, 4, 4, 1, 1];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '插金花 - 状元');
    });

    test('五红 - 五红', () {
      // List<int> diceValues = [4, 4, 4, 4, 4, 2];
      List<int> diceValues = [4, 4, 4, 4, 4, 5];

      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '五红 - 五红');
    });

    test('五子登科 - 五子登科', () {
      // List<int> diceValues = [3, 3, 3, 3, 3, 2];
      //5个5
      // List<int> diceValues = [5, 5, 5, 5, 5, 4];
      //5个1
      List<int> diceValues = [1, 1, 1, 1, 1, 6];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '五子登科 - 五子登科');
    });

    test('四红 - 四红', () {
      // 错误????????????????????????????????????????????
      List<int> diceValues = [4, 4, 4, 4, 5, 3];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '四红 - 四红');
    });

    test('对堂 - 榜眼', () {
      List<int> diceValues = [1, 3, 3, 4, 5, 6];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '对堂 - 榜眼');
    });

    test('三红 - 探花', () {
      List<int> diceValues = [4, 4, 4, 2, 3, 5];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '三红 - 探花');
    });

    test('四进 - 进士', () {
      // List<int> diceValues = [2, 2, 2, 2, 3, 4];
      // 四个3
      // List<int> diceValues = [3, 3, 3, 3, 4, 5];
      // 4个2
      List<int> diceValues = [2, 2, 2, 2, 3, 4];

      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '四进 - 进士');
    });

    test('二举 - 举人', () {
      List<int> diceValues = [4, 4, 2, 3, 5, 6];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '二举 - 举人');
    });

    test('一秀 - 秀才', () {
      List<int> diceValues = [4, 2, 3, 5, 6, 3];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '一秀 - 秀才');
    });

    test('未中奖', () {
      List<int> diceValues = [2, 3, 5, 6, 1, 2];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '未中奖');
    });

    // 额外测试：组合未覆盖的情况
    test('组合未覆盖情况 - 未中奖', () {
      List<int> diceValues = [1, 1, 1, 2, 3, 4];
      String rank = determineRankLogic(diceValues);
      print(rank);
      expect(rank, '未中奖');
    });
  });
}
