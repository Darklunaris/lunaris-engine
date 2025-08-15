import 'package:test/test.dart';
import 'package:lunaris_engine/numerical/bisection.dart';

void main() {
  test('bisection sqrt2', () {
    final r = bisection((x) => x * x - 2, 0.0, 2.0);
    expect((r - 1.41421356237).abs() < 1e-10, isTrue);
  });
}
