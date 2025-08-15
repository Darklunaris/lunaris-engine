import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final X = [
    [1.0],
    [2.0],
    [3.0],
    [4.0],
  ];
  final y = [1.0, 2.0, 3.0, 4.0];
  final xg = XGBoostLikeRegressor(nEstimators: 10, learningRate: 0.1);
  xg.fit(X, y);
  print(xg.predictOne([2.5]));
}
