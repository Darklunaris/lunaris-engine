import 'package:lunaris_engine/Set/is_frequency_unique.dart';
import 'package:test/test.dart';

void main() {
  group('isFrequencyUnique', () {
    test('unique frequencies - simple case', () {
      expect(isFrequencyUnique([1, 2, 2, 3, 3, 3]), isTrue);
    });

    test('non-unique frequencies', () {
      expect(isFrequencyUnique([1, 2, 2, 3, 3]), isFalse);
    });

    test('empty list - considered unique', () {
      expect(isFrequencyUnique([]), isTrue);
    });

    test('single repeated element', () {
      expect(isFrequencyUnique(['a', 'a', 'a']), isTrue);
    });

    test('mixed string frequencies - non-unique', () {
      expect(isFrequencyUnique(['a', 'a', 'b', 'b']), isFalse);
    });

    test('mixed string frequencies - unique', () {
      expect(isFrequencyUnique(['a', 'a', 'a', 'b', 'b']), isTrue);
    });

    test('duplicates in frequency values', () {
      expect(isFrequencyUnique([4, 4, 4, 5, 5, 5]), isFalse);
    });
  });
}
