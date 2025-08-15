import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final X = [
    [1.0],
    [2.0],
    [3.0],
    [4.0],
  ];
  final y = [1.0, 2.0, 3.0, 4.0];
  final lgb = LightGBMLikeRegressor(nEstimators: 10, learningRate: 0.1);
  lgb.fit(X, y);
  print(lgb.predictOne([2.5]));
}
