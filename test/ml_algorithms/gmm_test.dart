import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/gmm.dart';

void main() {
  test('gmm basic', () {
    final X = [
      [1.0, 2.0],
      [1.1, 2.1],
      [8.0, 8.0],
    ];
    final model = GMM(2);
    model.fit(X);
    final label = model.predict([1.0, 2.0]);
    expect(label >= 0, isTrue);
  });
}
