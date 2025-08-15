import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final X = [
    [1.0],
    [1.1],
    [3.0],
    [3.1],
  ];
  final y = [0, 0, 1, 1];
  final gnb = GaussianNB();
  gnb.fit(X, y);
  print(gnb.predict([1.05])); // 0
}
