import 'package:lunaris_engine/MachineLearning/bayesian_optimization.dart';

void main() {
  // This example demonstrates creating a BO instance with synthetic initial data.
  final initialX = [
    [0.0],
    [5.0],
    [10.0],
  ];
  final initialY = [
    -(0.0 - 3.0) * (0.0 - 3.0),
    -(5.0 - 3.0) * (5.0 - 3.0),
    -(10.0 - 3.0) * (10.0 - 3.0),
  ];
  final bo = BayesianOptimization(
    initialX: initialX,
    initialY: initialY,
    lower: [0.0],
    upper: [10.0],
    seed: 42,
  );
  // Note: the evaluate method is intentionally not implemented; BO here
  // requires the client to provide real objective evaluations via initial data.
  final res = bo.optimize(budget: 5);
  print('bestX=${res['bestX']} bestY=${res['bestY']}');
}
