import 'package:lunaris_engine/map/most_frequent_element.dart';
import 'package:test/test.dart';

void main() {
  group('Most Frequent Element Tests', () {
    test('Finds most frequent integer element', () {
      expect(mostFrequentElement<int>([1, 3, 2, 3, 4, 3, 5, 1]), 3);
      expect(mostFrequentElement<int>([1, 1, 1, 2, 2]), 1);
      expect(mostFrequentElement<int>([5, 4, 4, 5, 5]), 5);
    });

    test('Returns null on empty list', () {
      expect(mostFrequentElement<int>([]), isNull);
    });

    test('Works with Strings', () {
      expect(mostFrequentElement<String>(['a', 'b', 'b', 'a', 'b']), 'b');
      expect(mostFrequentElement<String>(['x']), 'x');
    });
  });
}
