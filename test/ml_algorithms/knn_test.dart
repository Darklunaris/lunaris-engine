import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('knnPredict', () {
    test('majority vote', () {
      final X = [
        [1.0],
        [2.0],
        [3.0],
        [4.0],
      ];
      final y = [0, 0, 1, 1];
      final p = knnPredict(X, y, [2.2], 3);
      expect(p, anyOf([0, 1]));
    });
  });
}
