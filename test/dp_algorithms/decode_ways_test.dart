import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/decode_ways.dart';

void main() {
  group('Decode Ways', () {
    test('basic cases', () {
      expect(numDecodings('12'), equals(2));
      expect(numDecodings('226'), equals(3));
    });
    test('leading zero invalid', () {
      expect(numDecodings('01'), equals(0));
    });
    test('empty string returns 0', () {
      expect(numDecodings(''), equals(0));
    });
  });
}
