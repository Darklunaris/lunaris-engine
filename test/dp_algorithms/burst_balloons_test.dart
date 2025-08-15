import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('maxCoins', () {
    test('example', () {
      expect(maxCoins([3, 1, 5, 8]), equals(167));
    });

    test('single', () {
      expect(maxCoins([5]), equals(5));
    });

    test('empty', () {
      expect(maxCoins([]), equals(0));
    });
  });
}
