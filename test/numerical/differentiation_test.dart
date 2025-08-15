import 'package:test/test.dart';
import 'package:lunaris_engine/numerical/differentiation.dart';
import 'dart:math' as math;

void main() {
  group('derivative', () {
    test('sin(x) at 0', () {
      final d = derivative(math.sin, 0.0);
      print('sin(x) at 0: computed=$d, expected=1.0, error=${(d - 1.0).abs()}');
      expect((d - 1.0).abs() < 1e-5, isTrue);
    });
    test('exp(x) at 1', () {
      final d = derivative(math.exp, 1.0);
      print(
        'exp(x) at 1: computed=$d, expected=${math.exp(1.0)}, error=${(d - math.exp(1.0)).abs()}',
      );
      expect((d - math.exp(1.0)).abs() < 1e-5, isTrue);
    });
    test('quadratic', () {
      final d = derivative((x) => 3 * x * x + 2 * x + 1, 2.0);
      print(
        'quadratic at 2: computed=$d, expected=14.0, error=${(d - 14.0).abs()}',
      );
      expect((d - (6 * 2.0 + 2)).abs() < 1e-5, isTrue);
    });
    test('high-frequency', () {
      final d = derivative((x) => math.sin(100 * x), 0.1);
      print(
        'high-frequency at 0.1: computed=$d, expected=${100 * math.cos(100 * 0.1)}, error=${(d - 100 * math.cos(100 * 0.1)).abs()}',
      );
      expect((d - 100 * math.cos(100 * 0.1)).abs() < 1e-4, isTrue);
    });
    test('richardson off', () {
      final d = derivative(math.sin, 0.0, richardson: false);
      print(
        'richardson off sin(x) at 0: computed=$d, expected=1.0, error=${(d - 1.0).abs()}',
      );
      expect((d - 1.0).abs() < 1e-4, isTrue);
    });
    test('constant', () {
      final d = derivative((x) => 42.0, 1.23);
      print('constant function: computed=$d, expected=0.0, error=${d.abs()}');
      expect(d.abs() < 1e-10, isTrue);
    });
  });
}
