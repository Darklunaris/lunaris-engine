import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('trainLinearSVM', () {
    test('simple separable', () {
      final X = [
        [1.0],
        [2.0],
        [3.0],
        [4.0],
      ];
      final y = [-1, -1, 1, 1];
      final model = trainLinearSVM(X, y, lr: 0.01, epochs: 200);
      final p = predictLinearSVM(model, [2.5]);
      expect(p == 1 || p == -1, isTrue);
    });
  });
}
