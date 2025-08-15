import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/transformer.dart';

void main() {
  group('Transformer', () {
    test('predict shape', () {
      final X = [
        [1, 2, 3],
      ];
      final model = Transformer(
        dModel: 16,
        heads: 2,
        vocabSize: 1000,
        headLayers: [
          16,
          8,
          16,
        ], // Fixed: includes input (16), hidden (8), output (16) sizes
      );
      final out = model.predict(X);
      expect(out.length, equals(1));
      expect(out[0].length, equals(16));
    });
  });
}
