import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final X = [
    [2.0],
    [3.0],
    [10.0],
    [11.0],
  ];
  final y = [0, 0, 1, 1];
  final rf = RandomForestClassifier(nEstimators: 5, maxDepth: 3);
  rf.fit(X, y);
  print(rf.predict([3.0]));
  print(rf.predict([10.5]));
}
