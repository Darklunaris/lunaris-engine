import 'package:lunaris_engine/MachineLearning/kmeans.dart';

void main() {
  final X = [
    [1.0, 2.0],
    [1.1, 2.1],
    [8.0, 8.0],
    [8.1, 8.2],
  ];
  final model = KMeans(2);
  model.fit(X);
  print(model.centroids);
  print(model.predict(X));
}
