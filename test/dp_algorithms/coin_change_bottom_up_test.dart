import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/coin_change_bottom_up.dart';

void main() {
  group('Coin Change Bottom-Up', () {
    test('example case', () {
      expect(coinChangeBottomUp([1, 2, 5], 11), equals(3));
    });
    test('impossible amount', () {
      expect(coinChangeBottomUp([2], 3), equals(-1));
    });
    test('zero amount', () {
      expect(coinChangeBottomUp([1, 2], 0), equals(0));
    });
  });
}
