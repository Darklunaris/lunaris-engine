import 'package:test/test.dart';
import 'package:lunaris_engine/numerical/newton_raphson.dart';

void main() {
  test('newton sqrt2', () {
    final r = newtonRaphson((x) => x * x - 2, (x) => 2 * x, 1.0);
    expect((r - 1.41421356237).abs() < 1e-10, isTrue);
  });
}
