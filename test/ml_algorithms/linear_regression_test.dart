import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('linearRegressionFit', () {
    test('perfect line', () {
      final X = [
        [1.0],
        [2.0],
        [3.0],
      ];
      final y = [3.0, 5.0, 7.0];
      final coeffs = linearRegressionFit(X, y);
      expect(coeffs[0], closeTo(1.0, 1e-6));
      expect(coeffs[1], closeTo(2.0, 1e-6));
    });
  });
}
