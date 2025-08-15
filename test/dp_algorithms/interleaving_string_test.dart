import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/interleaving_string.dart';

void main() {
  group('Interleaving String', () {
    test('true case', () {
      expect(isInterleave('aab', 'axy', 'aaxaby'), isTrue);
    });
    test('false case', () {
      expect(isInterleave('a', 'b', 'abx'), isFalse);
    });
    test('empty strings', () {
      expect(isInterleave('', '', ''), isTrue);
    });
  });
}
