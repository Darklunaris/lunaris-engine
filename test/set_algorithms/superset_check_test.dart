import 'package:test/test.dart';
import 'package:lunaris_engine/Set/superset_check.dart';

void main() {
  test('isSuperset basic', () {
    expect(isSuperset({1, 2, 3}, {2, 3}), isTrue);
    expect(isSuperset({1, 2}, {2, 3}), isFalse);
    expect(isSuperset({1, 2, 3}, <int>{}), isTrue);
  });
}
