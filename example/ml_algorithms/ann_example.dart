import 'package:lunaris_engine/MachineLearning/ann.dart';

void main() {
  final X = [
    [0.0, 0.0],
    [0.0, 1.0],
    [1.0, 0.0],
    [1.0, 1.0],
  ];
  final y = [
    [0.0],
    [1.0],
    [1.0],
    [0.0],
  ];
  final model = ANN(layers: [2, 4, 1], epochs: 10, lr: 0.01);
  model.fit(X, y);
  print(model.predict(X));
}
