import 'package:test/test.dart';
import 'package:lunaris_engine/ListAdvancedSorts/stooge_sort.dart';

void main() {
  group('Stooge Sort', () {
    test('Sorts integers', () {
      final arr = [2, 4, 5, 3, 1];
      stoogeSort(arr);
      expect(arr, equals([1, 2, 3, 4, 5]));
    });
    test('Sorts doubles', () {
      final arr = [3.2, 1.5, 4.8, 2.1];
      stoogeSort(arr);
      expect(arr, equals([1.5, 2.1, 3.2, 4.8]));
    });
    test('Sorts strings', () {
      final arr = ['banana', 'apple', 'cherry'];
      stoogeSort(arr);
      expect(arr, equals(['apple', 'banana', 'cherry']));
    });
    test('Empty list', () {
      final arr = <int>[];
      stoogeSort(arr);
      expect(arr, equals([]));
    });
  });
}
