import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/policy_gradient.dart';

void main() {
  group('PolicyGradient', () {
    test('selectAction returns valid index', () {
      final pg = PolicyGradient(nActions: 2, policyLayers: [3, 8, 2], seed: 2);
      final a = pg.selectAction([0.0, 0.0, 0.0]);
      expect(a, inInclusiveRange(0, 1));
    });
  });
}
