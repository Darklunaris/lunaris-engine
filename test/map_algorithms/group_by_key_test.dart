import 'package:lunaris_engine/map/group_by_key.dart';
import 'package:test/test.dart';

void main() {
  group('groupByKey', () {
    test('groups strings by first uppercase letter', () {
      final words = [
        'Alice',
        'Ahmed',
        'Bob',
        'Amal',
        'adam',
        'Bashar',
        'Brian',
        '',
      ];
      final grouped = groupByKey<String, String>(
        words.where((w) => w.isNotEmpty).toList(),
        (word) => word[0].toUpperCase(),
      );
      expect(grouped['A'], containsAll(['Alice', 'Ahmed', 'Amal', 'adam']));
      expect(grouped['B'], containsAll(['Bob', 'Bashar', 'Brian']));
      expect(grouped.containsKey(''), isFalse);
    });

    test('groups integers by parity (even/odd)', () {
      final numbers = [1, 2, 3, 4, 5, 6];
      final grouped = groupByKey<int, String>(
        numbers,
        (n) => n.isEven ? 'even' : 'odd',
      );
      expect(grouped['even'], equals([2, 4, 6]));
      expect(grouped['odd'], equals([1, 3, 5]));
    });

    test('empty list returns empty map', () {
      final result = groupByKey<String, String>([], (x) => x);
      expect(result, isEmpty);
    });
  });
}
