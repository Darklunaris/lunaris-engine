import 'package:test/test.dart';
import 'package:lunaris_engine/map/merge_maps_conflict.dart';

void main() {
  test('mergeMaps with sum conflict', () {
    final a = {'x': 1, 'y': 2};
    final b = {'y': 3, 'z': 4};
    final merged = mergeMaps(a, b, (k, v1, v2) => v1 + v2);
    expect(merged, equals({'x': 1, 'y': 5, 'z': 4}));
  });
}
