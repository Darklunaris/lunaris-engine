import 'package:lunaris_engine/MachineLearning/gru.dart';

void main() {
  final X = [
    [
      [0.1, 0.2],
      [0.2, 0.1],
    ],
  ];
  final y = [
    [1.0],
  ];
  final model = GRU(inputSize: 2, hiddenSize: 6, readoutLayers: [1]);
  model.fit(X, y);
  print(model.predict(X));
}
