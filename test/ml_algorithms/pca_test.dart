import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/pca.dart';

void main() {
  test('pca basic', () {
    final X = [
      [1.0, 2.0],
      [1.1, 2.1],
      [0.9, 1.8],
    ];
    final pca = PCA(components: 1);
    final out = pca.fitTransform(X);
    expect(out['projected'].length, equals(3));
  });
}
