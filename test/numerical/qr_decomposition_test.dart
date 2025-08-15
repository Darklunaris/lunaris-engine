import 'package:test/test.dart';
import 'package:lunaris_engine/numerical/qr_decomposition.dart';

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

List<List<double>> transpose(List<List<double>> a) {
  final int n = a.length;
  final int m = a[0].length;
  return List.generate(m, (i) => List.generate(n, (j) => a[j][i]));
}

void main() {
  group('qrDecomposition', () {
    test('simple 3x3', () {
      final List<List<double>> a = [
        [12.0, -51.0, 4.0],
        [6.0, 167.0, -68.0],
        [-4.0, 24.0, -41.0],
      ];
      final Map<String, List<List<double>>> res = qrDecomposition(a);
      final List<List<double>> q = res['Q']!;
      final List<List<double>> r = res['R']!;
      final List<List<double>> qr = matmul(q, r);
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          expect((a[i][j] - qr[i][j]).abs() < 1e-8, isTrue);
        }
      }
      // Q orthogonality
      final List<List<double>> qtq = matmul(transpose(q), q);
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          expect((qtq[i][j] - (i == j ? 1.0 : 0.0)).abs() < 1e-8, isTrue);
        }
      }
    });
    test('random 4x4', () {
      List<List<double>> rnd() => List.generate(
        4,
        (_) => List.generate(
          4,
          (_) => 10 * (0.5 - (DateTime.now().microsecond % 1000) / 1000),
        ),
      );
      final List<List<double>> a = rnd();
      final Map<String, List<List<double>>> res = qrDecomposition(a);
      final List<List<double>> q = res['Q']!;
      final List<List<double>> r = res['R']!;
      final List<List<double>> qr = matmul(q, r);
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          expect((a[i][j] - qr[i][j]).abs() < 1e-8, isTrue);
        }
      }
      // Q orthogonality
      final List<List<double>> qtq = matmul(transpose(q), q);
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          expect((qtq[i][j] - (i == j ? 1.0 : 0.0)).abs() < 1e-8, isTrue);
        }
      }
    });
  });
}
