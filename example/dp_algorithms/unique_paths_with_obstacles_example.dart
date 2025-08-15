import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final grid = [
    [0, 0, 0],
    [0, 1, 0],
    [0, 0, 0],
  ];
  print('Unique paths with obstacles => ${uniquePathsWithObstacles(grid)}');
}
