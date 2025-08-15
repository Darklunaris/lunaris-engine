import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('logisticRegressionFit', () {
    test('simple separable', () {
      final X = [
        [0.0],
        [1.0],
        [2.0],
        [3.0],
      ];
      final y = [0, 0, 1, 1];
      final w = logisticRegressionFit(X, y, lr: 0.5, epochs: 800);
      final c0 = logisticRegressionPredictClass(w, [0.5]);
      final c1 = logisticRegressionPredictClass(w, [2.5]);
      expect(c0, equals(0));
      expect(c1, equals(1));
    });
  });
}
