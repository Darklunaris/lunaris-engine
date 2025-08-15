import 'package:test/test.dart';
import 'package:lunaris_engine/ListAdvancedSorts/odd_even_sort.dart';

void main() {
  group('Odd-Even Sort', () {
    test('Sorts integers', () {
      final arr = [5, 3, 2, 4, 1];
      oddEvenSort(arr);
      expect(arr, equals([1, 2, 3, 4, 5]));
    });
    test('Sorts doubles', () {
      final arr = [3.2, 1.5, 4.8, 2.1];
      oddEvenSort(arr);
      expect(arr, equals([1.5, 2.1, 3.2, 4.8]));
    });
    test('Sorts strings', () {
      final arr = ['banana', 'apple', 'cherry'];
      oddEvenSort(arr);
      expect(arr, equals(['apple', 'banana', 'cherry']));
    });
    test('Empty list', () {
      final arr = <int>[];
      oddEvenSort(arr);
      expect(arr, equals([]));
    });
  });
}
