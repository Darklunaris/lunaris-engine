import 'package:test/test.dart';
import 'package:lunaris_engine/Set/power_set.dart';

void main() {
  test('powerSet basic', () {
    final result = powerSet({1, 2});
    expect(
      result,
      containsAll([
        <int>{},
        {1},
        {2},
        {1, 2},
      ]),
    );
    expect(result.length, equals(4));
  });
}
