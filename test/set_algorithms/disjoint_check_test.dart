import 'package:test/test.dart';
import 'package:lunaris_engine/Set/disjoint_check.dart';

void main() {
  test('isDisjoint basic', () {
    expect(isDisjoint({1, 2}, {3, 4}), isTrue);
    expect(isDisjoint({1, 2}, {2, 3}), isFalse);
    expect(isDisjoint(<int>{}, {1, 2}), isTrue);
  });
}
