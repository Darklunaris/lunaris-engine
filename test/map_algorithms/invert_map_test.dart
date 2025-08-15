import 'package:test/test.dart';
import 'package:lunaris_engine/map/invert_map.dart';

void main() {
  test('invertMap basic', () {
    expect(invertMap({'a': 1, 'b': 2}), equals({1: 'a', 2: 'b'}));
    expect(invertMap({'a': 1, 'b': 1}), equals({1: 'b'}));
    expect(invertMap(<String, int>{}), isEmpty);
  });
}
