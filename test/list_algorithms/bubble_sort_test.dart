import 'package:test/test.dart';
import 'package:lunaris_engine/List/bubble_sort.dart';

void main() {
  group('Bubble Sort Tests', () {
    test('Sorts integers correctly', () {
      List<int> list = [64, 34, 25, 12, 22, 11, 90];
      bubbleSort<int>(list);
      expect(list, equals([11, 12, 22, 25, 34, 64, 90]));
    });

    test('Sorts doubles correctly', () {
      List<double> list = [3.1, 2.5, 4.0, 1.9];
      bubbleSort<double>(list);
      expect(list, equals([1.9, 2.5, 3.1, 4.0]));
    });

    test('Sorts strings alphabetically', () {
      List<String> list = ['banana', 'apple', 'cherry'];
      bubbleSort<String>(list);
      expect(list, equals(['apple', 'banana', 'cherry']));
    });

    test('Works with an empty list', () {
      List<int> list = [];
      bubbleSort<int>(list);
      expect(list, equals([]));
    });

    test('Works with a single element', () {
      List<int> list = [42];
      bubbleSort<int>(list);
      expect(list, equals([42]));
    });
  });
}
