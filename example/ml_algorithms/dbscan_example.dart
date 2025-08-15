import 'package:lunaris_engine/MachineLearning/dbscan.dart';

void main() {
  final X = [
    [1.0, 2.0],
    [1.1, 2.1],
    [8.0, 8.0],
    [8.1, 8.1],
  ];
  final model = DBSCAN(eps: 0.5, minPts: 1);
  final labels = model.fit(X);
  print(labels);
}
