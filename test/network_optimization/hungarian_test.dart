import 'package:test/test.dart';
import 'package:lunaris_engine/networkop/hungarian.dart';

void main() {
  test('Hungarian assignment', () {
    final cost = [
      [4, 1, 3],
      [2, 0, 5],
      [3, 2, 2],
    ];
    final res = hungarian(cost);
    expect(res[0], equals(5));
    expect((res[1] as List).length, equals(3));
  });
}
