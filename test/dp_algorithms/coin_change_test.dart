import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/coin_change.dart';

void main() {
  group('Coin Change', () {
    test('Standard cases', () {
      expect(coinChange([1, 2, 5], 11), equals(3)); // 5+5+1
      expect(coinChange([2], 3), equals(-1));
      expect(coinChange([1], 0), equals(0));
    });
    test('Impossible case', () {
      expect(coinChange([2, 4], 7), equals(-1));
    });
    test('Single coin', () {
      expect(coinChange([3], 9), equals(3));
    });
    test('Empty coins', () {
      expect(coinChange([], 5), equals(-1));
    });
  });
}
