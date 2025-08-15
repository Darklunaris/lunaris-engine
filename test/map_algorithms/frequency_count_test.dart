import 'package:lunaris_engine/map/frequency_count.dart';
import 'package:test/test.dart';

void main() {
  group('frequencyCount', () {
    test('counts frequency of integers', () {
      expect(frequencyCount([1, 2, 2, 3]), equals({1: 1, 2: 2, 3: 1}));
    });

    test('counts frequency of strings', () {
      expect(
        frequencyCount(['a', 'b', 'a', 'c', 'b', 'a']),
        equals({'a': 3, 'b': 2, 'c': 1}),
      );
    });

    test('empty list returns empty map', () {
      expect(frequencyCount([]), isEmpty);
    });

    test('single repeated value', () {
      expect(frequencyCount([5, 5, 5, 5]), equals({5: 4}));
    });

    test('mixed types (rare but valid)', () {
      expect(frequencyCount<dynamic>([1, '1', 1]), equals({1: 2, '1': 1}));
    });
  });
}
