import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('CatBoostLikeRegressor', () {
    test('fit predict basic', () {
      final X = [
        [1.0],
        [2.0],
        [3.0],
        [4.0],
      ];
      final y = [1.0, 2.0, 3.0, 4.0];
      final cb = CatBoostLikeRegressor(nEstimators: 5, learningRate: 0.1);
      cb.fit(X, y);
      final p = cb.predictOne([2.5]);
      expect(p, isA<double>());
    });
  });
}
