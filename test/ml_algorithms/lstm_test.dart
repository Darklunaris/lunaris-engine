import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/lstm.dart';

void main() {
  group('LSTM', () {
    test('predict shape', () {
      final X = [
        [
          [0.1, 0.0],
          [0.2, 0.1],
        ],
      ];
      final model = LSTM(
        inputSize: 2,
        hiddenSize: 5,
        readoutLayers: [5, 5], // Fixed: includes input (5) and output (5) sizes
      );
      final out = model.predict(X);
      expect(out.length, equals(1));
      expect(out[0].length, equals(5));
    });
  });
}
