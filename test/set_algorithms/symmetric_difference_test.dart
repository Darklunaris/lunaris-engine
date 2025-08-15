import 'package:test/test.dart';
import 'package:lunaris_engine/Set/symmetric_difference.dart';

void main() {
  test('symmetricDifference basic', () {
    expect(symmetricDifference({1, 2, 3}, {3, 4, 5}), equals({1, 2, 4, 5}));
    expect(symmetricDifference({1, 2}, {1, 2}), isEmpty);
    expect(symmetricDifference(<int>{}, {1, 2}), equals({1, 2}));
  });
}
