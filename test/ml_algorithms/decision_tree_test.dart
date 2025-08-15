import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('DecisionTreeClassifier', () {
    test('simple split', () {
      final X = [
        [2.0],
        [3.0],
        [10.0],
        [11.0],
      ];
      final y = [0, 0, 1, 1];
      final tree = DecisionTreeClassifier(maxDepth: 2);
      tree.fit(X, y);
      expect(tree.predict([2.5]), equals(0));
      expect(tree.predict([10.5]), equals(1));
    });
  });
}
