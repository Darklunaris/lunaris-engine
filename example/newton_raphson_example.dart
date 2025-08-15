import 'package:lunaris_engine/numerical/newton_raphson.dart';

void main() {
  final root = newtonRaphson((x) => x * x - 2, null, 1.0);
  print('sqrt(2) ~ $root');
}
