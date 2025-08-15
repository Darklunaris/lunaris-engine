import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/kmeans.dart';

void main() {
  test('kmeans simple', () {
    final X = [
      [1.0, 2.0],
      [1.1, 2.1],
      [8.0, 8.0],
      [8.1, 8.2],
    ];
    final k = KMeans(2);
    k.fit(X);
    final labels = k.predict(X);
    expect(labels.where((v) => v == labels[0]).length >= 2, isTrue);
  });
}
