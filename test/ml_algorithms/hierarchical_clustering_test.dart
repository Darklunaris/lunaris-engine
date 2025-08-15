import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/hierarchical_clustering.dart';

void main() {
  test('hierarchical small', () {
    final X = [
      [1.0, 2.0],
      [1.1, 2.1],
      [8.0, 8.0],
    ];
    final model = HierarchicalClustering();
    final labels = model.fit(X, k: 2);
    expect(labels.length, equals(3));
  });
}
