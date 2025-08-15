import 'package:test/test.dart';
import 'package:lunaris_engine/ListAdvancedSorts/cycle_sort.dart';

void main() {
  group('Cycle Sort', () {
    test('Sorts integers', () {
      final arr = [20, 40, 50, 10, 30];
      cycleSort(arr);
      expect(arr, equals([10, 20, 30, 40, 50]));
    });
    test('Sorts doubles', () {
      final arr = [3.2, 1.5, 4.8, 2.1];
      cycleSort(arr);
      expect(arr, equals([1.5, 2.1, 3.2, 4.8]));
    });
    test('Sorts strings', () {
      final arr = ['banana', 'apple', 'cherry'];
      cycleSort(arr);
      expect(arr, equals(['apple', 'banana', 'cherry']));
    });
    test('Empty list', () {
      final arr = <int>[];
      cycleSort(arr);
      expect(arr, equals([]));
    });
  });
}
