import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/gru.dart';

void main() {
  group('GRU', () {
    test('predict shape', () {
      final X = [
        [
          [0.1, 0.0],
          [0.2, 0.1],
        ],
      ];
      final model = GRU(
        inputSize: 2,
        hiddenSize: 4,
        readoutLayers: [4, 4], // Fixed: includes input (4) and output (4) sizes
      );
      final out = model.predict(X);
      expect(out.length, equals(1));
      expect(out[0].length, equals(4));
    });
  });
}
