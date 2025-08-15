import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final X = [
    [1.0],
    [2.0],
    [3.0],
    [4.0],
  ];
  final y = [-1, -1, 1, 1];
  final model = trainLinearSVM(X, y, lr: 0.01, epochs: 200);
  print(predictLinearSVM(model, [2.5]));
}
