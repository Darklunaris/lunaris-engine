import 'package:test/test.dart';
import 'package:lunaris_engine/map/index_mapping.dart';

void main() {
  test('indexMapping basic', () {
    final list = ['a', 'b', 'a', 'c', 'b', 'a'];
    final result = indexMapping(list);
    expect(result['a'], equals([0, 2, 5]));
    expect(result['b'], equals([1, 4]));
    expect(result['c'], equals([3]));
  });
}
