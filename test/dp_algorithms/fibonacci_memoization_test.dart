import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/fibonacci_memoization.dart';

void main() {
  group('Fibonacci Memoization', () {
    test('Base cases', () {
      expect(fibonacciMemo(0), equals(0));
      expect(fibonacciMemo(1), equals(1));
    });

    test('Small n', () {
      expect(fibonacciMemo(5), equals(5));
      expect(fibonacciMemo(10), equals(55));
    });

    test('Larger n', () {
      expect(fibonacciMemo(30), equals(832040));
    });

    test('Memoization works', () {
      final memo = <int, int>{};
      expect(fibonacciMemo(15, memo), equals(610));
      // Should not recompute
      expect(memo[15], equals(610));
    });
  });
}
