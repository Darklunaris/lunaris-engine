import 'package:lunaris_engine/map/first_non_repeated_element.dart';
import 'package:test/test.dart';

void main() {
  test('finds first non-repeated element in string list', () {
    expect(
      firstNonRepeatedElement<String>(['a', 'a', 'b', 'b', 'c', 'd', 'e']),
      'c',
    );
    expect(
      firstNonRepeatedElement<String>(['a', 'a', 'b', 'b', 'c', 'c']),
      isNull,
    );
  });

  test('finds first non-repeated element in int list', () {
    expect(firstNonRepeatedElement<int>([1, 2, 2, 3, 3]), 1);
    expect(firstNonRepeatedElement<int>([1, 1, 2, 2]), isNull);
  });
}
