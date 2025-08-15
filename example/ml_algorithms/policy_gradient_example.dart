import 'package:lunaris_engine/MachineLearning/policy_gradient.dart';

void main() {
  final pg = PolicyGradient(nActions: 2, policyLayers: [3, 8, 2], seed: 1);
  final a = pg.selectAction([0.1, 0.2, 0.3]);
  print('action=$a');
}
