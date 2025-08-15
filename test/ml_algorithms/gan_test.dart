import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/gan.dart';

void main() {
  group('GAN', () {
    test('generate shape', () {
      final model = GAN(
        latentDim: 8,
        genLayers: [
          8,
          16,
          32,
          8,
        ], // Fixed: includes input (8), hidden (16, 32), output (8) sizes
        discLayers: [
          8,
          32,
          16,
          1,
        ], // Fixed: includes input (8), hidden (32, 16), output (1) sizes
      );
      final out = model.generate(3);
      expect(out.length, equals(3));
      expect(out[0].length, equals(8));
    });
  });
}
