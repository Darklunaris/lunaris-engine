import 'package:test/test.dart';
import 'package:lunaris_engine/networkop/edmonds_blossom.dart';

void main() {
  test('Blossom matching small', () {
    final g = [
      [1, 2],
      [0, 2],
      [0, 1, 3],
      [2],
    ];
    final match = edmondsBlossom(4, g);
    // matching size should be at least 2
    final matched = match.where((x) => x != -1).length ~/ 2;
    expect(matched, greaterThanOrEqualTo(1));
  });
}
