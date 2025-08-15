import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('GradientBoostingRegressor', () {
    test('fit predict basic', () {
      final X = [
        [1.0],
        [2.0],
        [3.0],
        [4.0],
      ];
      final y = [1.0, 2.0, 3.0, 4.0];
      final gb = GradientBoostingRegressor(nEstimators: 5, learningRate: 0.1);
      gb.fit(X, y);
      final p = gb.predictOne([2.5]);
      expect(p, isA<double>());
    });
  });
}
