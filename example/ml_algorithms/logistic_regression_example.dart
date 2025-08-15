import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final X = [
    [0.0],
    [1.0],
    [2.0],
    [3.0],
  ];
  final y = [0, 0, 1, 1];
  final w = logisticRegressionFit(X, y, lr: 0.5, epochs: 1000);
  print(w);
  print(logisticRegressionPredictClass(w, [1.5]));
}
