import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/cnn.dart';

void main() {
  group('CNN', () {
    test('predict shape', () {
      final X = [
        [
          [
            [0.0],
            [0.0],
          ],
          [
            [0.0],
            [0.0],
          ],
        ],
      ];
      // Fixed: headLayers must include input size (4 features per channel) and output size (1)
      // 4 features per channel: mean, std, min, max
      final model = CNN(
        height: 2,
        width: 2,
        channels: 1,
        headLayers: [4, 2, 1], // 4 input features, 2 hidden, 1 output
      );
      final out = model.predict(X);
      expect(out.length, equals(1));
      expect(out[0].length, equals(1));
    });
  });
}
