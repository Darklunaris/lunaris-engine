import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/rnn.dart';

void main() {
  group('RNN', () {
    test('predict shape', () {
      final X = [
        [
          [0.1, 0.0],
          [0.2, 0.1],
        ],
      ];
      final model = RNN(
        inputSize: 2,
        hiddenSize: 3,
        readoutLayers: [3, 3], // Fixed: includes input (3) and output (3) sizes
      );
      final out = model.predict(X);
      expect(out.length, equals(1));
      expect(out[0].length, equals(3));
    });
  });
}
