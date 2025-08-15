import 'package:lunaris_engine/MachineLearning/tsne.dart';

void main() {
  final X = [
    [1.0, 2.0],
    [1.1, 2.1],
    [0.9, 1.8],
  ];
  final Y = tsne(X, dim: 2, iterations: 5);
  print(Y);
}
