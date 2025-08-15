import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final X = [
    [1.0],
    [2.0],
    [3.0],
    [4.0],
  ];
  final y = [0, 0, 1, 1];
  final gbc = GradientBoostingClassifier(nEstimators: 10, learningRate: 0.1);
  gbc.fit(X, y);
  print(gbc.predict([2.5]));
}
