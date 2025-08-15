import 'package:lunaris_engine/MachineLearning/autoencoder.dart';

void main() {
  final X = [
    [1.0, 0.0, 0.0],
    [0.0, 1.0, 0.0],
  ];
  final model = Autoencoder(2, epochs: 1, lr: 0.001);
  model.fit(X);
  print(model.encode(X));
}
