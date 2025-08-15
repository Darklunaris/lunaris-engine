import 'package:lunaris_engine/MachineLearning/lstm.dart';

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
  final model = LSTM(hiddenSize: 8, inputSize: 2, readoutLayers: [1]);
  model.fit(X, y);
  print(model.predict(X));
}
