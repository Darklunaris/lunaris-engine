import 'package:test/test.dart';
import 'package:lunaris_engine/ListAdvancedSorts/gnome_sort.dart';

void main() {
  group('Gnome Sort', () {
    test('Sorts integers', () {
      final arr = [34, 2, 10, -9];
      gnomeSort(arr);
      expect(arr, equals([-9, 2, 10, 34]));
    });
    test('Sorts doubles', () {
      final arr = [3.2, 1.5, 4.8, 2.1];
      gnomeSort(arr);
      expect(arr, equals([1.5, 2.1, 3.2, 4.8]));
    });
    test('Sorts strings', () {
      final arr = ['banana', 'apple', 'cherry'];
      gnomeSort(arr);
      expect(arr, equals(['apple', 'banana', 'cherry']));
    });
    test('Empty list', () {
      final arr = <int>[];
      gnomeSort(arr);
      expect(arr, equals([]));
    });
  });
}
