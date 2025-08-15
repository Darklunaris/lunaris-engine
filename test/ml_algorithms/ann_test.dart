import 'dart:io';
import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/ann.dart';

void main() {
  group('ANN', () {
    test('predict shape', () {
      final X = [
        [0.0, 1.0],
        [1.0, 0.0],
      ];
      final model = ANN(layers: [2, 3, 1]);
      final out = model.predict(X);
      expect(out.length, equals(2));
      expect(out[0].length, equals(1));
    });

    test('training reduces loss on tiny dataset', () {
      // simple regression: y = x0 + x1
      final X = [
        [0.0, 0.0],
        [0.0, 1.0],
        [1.0, 0.0],
        [1.0, 1.0],
      ];
      final Y = [
        [0.0],
        [1.0],
        [1.0],
        [2.0],
      ];

      final model = ANN(layers: [2, 4, 1], epochs: 200, lr: 0.05, seed: 42);
      final before = model.predict(X);
      double mseBefore = 0.0;
      for (var i = 0; i < before.length; i++) {
        final d = before[i][0] - Y[i][0];
        mseBefore += d * d;
      }
      mseBefore /= before.length;

      model.fit(X, Y);
      expect(model.lastLoss, isNotNull);
      expect(model.lastLoss!, lessThan(mseBefore));
    });

    test('serialize/deserialize preserves predictions', () {
      final X = [
        [0.0, 0.0],
        [0.0, 1.0],
        [1.0, 0.0],
        [1.0, 1.0],
      ];
      final Y = [
        [0.0],
        [1.0],
        [1.0],
        [2.0],
      ];
      final model = ANN(layers: [2, 4, 1], epochs: 100, lr: 0.05, seed: 7);
      model.fit(X, Y);
      final pred1 = model.predict(X);
      final m = model.toMap();
      final model2 = ANN.fromMap(m);
      final pred2 = model2.predict(X);
      expect(pred1.length, equals(pred2.length));
      for (var i = 0; i < pred1.length; i++) {
        expect((pred1[i][0] - pred2[i][0]).abs(), lessThan(1e-12));
      }
    });

    test('json and params helpers', () async {
      final X = [
        [0.0, 1.0],
        [1.0, 0.0],
      ];
      final Y = [
        [1.0],
        [1.0],
      ];
      final model = ANN(layers: [2, 3, 1], epochs: 50, lr: 0.05, seed: 3);
      model.fit(X, Y);
      final params = model.getParams();
      expect(params.containsKey('weights'), isTrue);
      final json = model.toJson();
      final model2 = ANN.fromJson(json);
      final p2 = model2.getParams();
      expect(p2['weights'].length, equals(params['weights'].length));

      // save to temp file and load
      final tmp = 'test_ml_ann_tmp.json';
      await model.saveToFile(tmp);
      final model3 = await ANN.loadFromFile(tmp);
      final p3 = model3.getParams();
      expect(p3['biases'].length, equals(params['biases'].length));
      // cleanup
      final f = File(tmp);
      if (f.existsSync()) f.deleteSync();
    });
  });
}
