import 'package:lunaris_engine/MachineLearning/cnn.dart';

void main() {
  // dummy single-channel 3x3 images
  final X = [
    [
      [
        [0.0],
        [1.0],
        [0.0],
      ],
      [
        [0.0],
        [1.0],
        [0.0],
      ],
      [
        [0.0],
        [1.0],
        [0.0],
      ],
    ],
  ];
  final y = [
    [1.0],
  ];
  final model = CNN(height: 3, width: 3, channels: 1, headLayers: [1]);
  model.fit(X, y);
  print(model.predict(X));
}
