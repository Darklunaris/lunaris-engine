import 'package:test/test.dart';
import 'package:lunaris_engine/numerical/integration.dart';
import 'dart:math' as math;

void main() {
  group('adaptiveSimpson', () {
    test('integrate x^2 from 0 to 1', () {
      final result = adaptiveSimpson((x) => x * x, 0, 1);
      expect((result - 1 / 3).abs() < 1e-7, isTrue);
    });
    test('integrate sin(x) from 0 to pi', () {
      final result = adaptiveSimpson(math.sin, 0, math.pi);
      expect((result - 2.0).abs() < 1e-7, isTrue);
    });
    test('integrate exp(x) from 0 to 1', () {
      final result = adaptiveSimpson(math.exp, 0, 1);
      expect((result - (math.exp(1) - 1)).abs() < 1e-7, isTrue);
    });
    test('nonsmooth function', () {
      final result = adaptiveSimpson((x) => x < 0.5 ? 1.0 : 2.0, 0, 1);
      expect((result - 1.5).abs() < 1e-6, isTrue);
    });
  });
  group('gaussLegendreFixedOrder', () {
    test('integrate x^2 from 0 to 1, order 5', () {
      final result = gaussLegendreFixedOrder((x) => x * x, 0, 1, order: 5);
      expect((result - 1 / 3).abs() < 1e-7, isTrue);
    });
    test('integrate sin(x) from 0 to pi, order 5', () {
      final result = gaussLegendreFixedOrder(math.sin, 0, math.pi, order: 5);
      // Order 5 is not enough for ultra-high accuracy; 1e-5 is realistic
      expect((result - 2.0).abs() < 1e-5, isTrue);
    });
    test('integrate exp(x) from 0 to 1, order 4', () {
      final result = gaussLegendreFixedOrder(math.exp, 0, 1, order: 4);
      expect((result - (math.exp(1) - 1)).abs() < 1e-6, isTrue);
    });
  });
}
