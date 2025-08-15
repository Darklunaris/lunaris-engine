import 'package:lunaris_engine/Set/has_unique_window.dart';
import 'package:test/test.dart';

void main() {
  group('hasUniqueWindow', () {
    test('window of size 3 with unique elements exists', () {
      expect(hasUniqueWindow([1, 2, 3, 1, 4, 5], 3), isTrue);
    });

    test('no unique window of size 2', () {
      expect(hasUniqueWindow([1, 1, 1, 1], 2), isFalse);
    });

    test('unique window at the end', () {
      expect(hasUniqueWindow([1, 2, 2, 3, 4, 5], 4), isTrue);
    });

    test('list shorter than k', () {
      expect(hasUniqueWindow([1, 2], 3), isFalse);
    });

    test('all unique elements', () {
      expect(hasUniqueWindow([5, 6, 7, 8, 9], 5), isTrue);
    });

    test('duplicates at edges, unique inside', () {
      expect(hasUniqueWindow(['a', 'b', 'a', 'c', 'd', 'e'], 4), isTrue);
    });

    test('non-integer types', () {
      expect(hasUniqueWindow<double>([1.1, 2.2, 3.3, 1.1], 3), isTrue);
    });
  });
}
