import 'package:test/test.dart';
import 'package:lunaris_engine/numerical/lu_decomposition.dart';

List<List<double>> matmul(List<List<double>> a, List<List<double>> b) {
  final int n = a.length;
  final int m = b[0].length;
  final int k = b.length;
  return List.generate(
    n,
    (i) => List.generate(
      m,
      (j) => List.generate(k, (l) => a[i][l] * b[l][j]).reduce((a, b) => a + b),
    ),
  );
}

List<List<double>> permuteRows(List<List<double>> a, List<int> p) {
  return List.generate(p.length, (i) => List.from(a[p[i]]));
}

void main() {
  group('luDecomposition', () {
    test('simple 2x2', () {
      final List<List<double>> a = [
        [4.0, 3.0],
        [6.0, 3.0],
      ];
      final Map<String, dynamic> res = luDecomposition(a)[0];
      final List<List<double>> l = res['L'] as List<List<double>>;
      final List<List<double>> u = res['U'] as List<List<double>>;
      final List<int> p = res['P'] as List<int>;
      final List<List<double>> pa = permuteRows(a, p);
      final List<List<double>> lu = matmul(l, u);
      for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
          expect((pa[i][j] - lu[i][j]).abs() < 1e-10, isTrue);
        }
      }
    });
    test('random 5x5', () {
      List<List<double>> rnd() => List.generate(
        5,
        (_) => List.generate(
          5,
          (_) => 10 * (0.5 - (DateTime.now().microsecond % 1000) / 1000),
        ),
      );
      final List<List<double>> a = rnd();
      final Map<String, dynamic> res = luDecomposition(a)[0];
      final List<List<double>> l = res['L'] as List<List<double>>;
      final List<List<double>> u = res['U'] as List<List<double>>;
      final List<int> p = res['P'] as List<int>;
      final List<List<double>> pa = permuteRows(a, p);
      final List<List<double>> lu = matmul(l, u);
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
          expect((pa[i][j] - lu[i][j]).abs() < 1e-8, isTrue);
        }
      }
    });
  });
}
