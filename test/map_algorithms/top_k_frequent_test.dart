import 'package:lunaris_engine/map/top_k_frequent.dart';
import 'package:test/test.dart';

void main() {
  group('Top K Frequent Elements Tests', () {
    test('Find top 2 frequent integers', () {
      expect(
        topKFrequent<int>([1, 1, 1, 2, 2, 3, 3, 3, 3], 2),
        containsAllInOrder([3, 1]),
      );
    });

    test('Top K greater than list length returns all elements', () {
      expect(topKFrequent<int>([1, 2, 3], 5).length, 3);
    });

    test('Empty list returns empty list', () {
      expect(topKFrequent<int>([], 3), isEmpty);
    });

    test('Works with strings', () {
      var list = ['a', 'b', 'b', 'a', 'b', 'c'];
      expect(topKFrequent<String>(list, 2), containsAllInOrder(['b', 'a']));
    });
  });
}
