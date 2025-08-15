import 'package:lunaris_engine/MachineLearning/gmm.dart';

void main() {
  final X = [
    [1.0, 2.0],
    [1.1, 2.1],
    [8.0, 8.0],
  ];
  final model = GMM(2);
  model.fit(X);
  print(model.predict([1.0, 2.0]));
}
