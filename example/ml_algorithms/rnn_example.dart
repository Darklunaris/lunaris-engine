import 'package:lunaris_engine/MachineLearning/rnn.dart';

void main() {
  final X = [
    [
      [0.1, 0.0],
      [0.2, 0.1],
    ],
  ];
  final y = [
    [1.0],
  ];
  final model = RNN(hiddenSize: 4, inputSize: 2, readoutLayers: [1]);
  model.fit(X, y);
  print(model.predict(X));
}
