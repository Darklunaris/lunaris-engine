import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('RandomForestClassifier', () {
    test('ensemble basic', () {
      final X = [
        [2.0],
        [3.0],
        [10.0],
        [11.0],
      ];
      final y = [0, 0, 1, 1];
      final rf = RandomForestClassifier(nEstimators: 7, maxDepth: 3);
      rf.fit(X, y);
      final p0 = rf.predict([2.5]);
      final p1 = rf.predict([10.2]);
      expect(p0, equals(0));
      expect(p1, equals(1));
    });
  });
}
