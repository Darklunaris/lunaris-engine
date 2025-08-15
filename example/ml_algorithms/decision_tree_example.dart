import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final X = [
    [2.0],
    [3.0],
    [10.0],
    [11.0],
  ];
  final y = [0, 0, 1, 1];
  final tree = DecisionTreeClassifier(maxDepth: 2);
  tree.fit(X, y);
  print(tree.predict([3.0])); // 0
  print(tree.predict([10.5])); // 1
}
