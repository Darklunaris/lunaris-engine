// import 'package:lunaris_engine/matrix_algorithms/flood_fill.dart';
// import 'package:lunaris_engine/matrix_algorithms/island_count_dfs.dart';
// import 'package:lunaris_engine/matrix_algorithms/island_count_bfs.dart';
// import 'package:lunaris_engine/matrix_algorithms/shortest_path_in_grid.dart';
// import 'package:lunaris_engine/matrix_algorithms/word_search.dart';
// import 'package:lunaris_engine/matrix_algorithms/path_sum.dart';
// import 'package:lunaris_engine/matrix_algorithms/matrix_rotation.dart';
// import 'package:lunaris_engine/matrix_algorithms/spiral_traversal.dart';
// import 'package:lunaris_engine/matrix_algorithms/surrounded_regions.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  // 🎨 Flood Fill
  var image = [
    [1, 1, 1],
    [1, 1, 0],
    [1, 0, 1],
  ];
  print('Flood Fill: ${floodFill(image, 1, 1, 2)}');

  // 🏝️ Island Count (DFS)
  var grid1 = [
    ['1', '1', '0', '0', '0'],
    ['1', '1', '0', '0', '0'],
    ['0', '0', '1', '0', '0'],
    ['0', '0', '0', '1', '1'],
  ];
  print('Island Count (DFS): ${numIslandsDFS(grid1)}');

  // 🏝️ Island Count (BFS)
  var grid2 = [
    ['1', '1', '0', '0', '0'],
    ['1', '1', '0', '0', '0'],
    ['0', '0', '1', '0', '0'],
    ['0', '0', '0', '1', '1'],
  ];
  print('Island Count (BFS): ${numIslandsBFS(grid2)}');

  // 🚦 Shortest Path in Grid
  var grid3 = [
    [1, 1, 0, 1],
    [1, 1, 1, 1],
    [0, 1, 0, 1],
    [1, 1, 1, 1],
  ];
  print('Shortest Path in Grid: ${shortestPathInGrid(grid3)}');

  // 🔍 Word Search in Grid
  var board = [
    ['A', 'B', 'C', 'E'],
    ['S', 'F', 'C', 'S'],
    ['A', 'D', 'E', 'E'],
  ];
  print('Word Search "ABCCED": ${wordSearch(board, "ABCCED")}');

  // ➕ Path Sum in Matrix
  var matrix = [
    [5, 4, 2],
    [1, 9, 1],
    [1, 1, 1],
  ];
  print('Path Sum 14: ${hasPathSum(matrix, 14)}');

  // 🔄 Matrix Rotation
  var mat = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];
  rotateMatrix(mat);
  print('Matrix Rotation: $mat');

  // 🌀 Spiral Traversal
  var spiral = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];
  print('Spiral Traversal: ${spiralOrder(spiral)}');

  // 🏝️ Surrounded Regions
  var board2 = [
    ['X', 'X', 'X', 'X'],
    ['X', 'O', 'O', 'X'],
    ['X', 'X', 'O', 'X'],
    ['X', 'O', 'X', 'X'],
  ];
  solveSurroundedRegions(board2);
  print('Surrounded Regions: $board2');
}
