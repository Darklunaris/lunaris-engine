// import 'package:lunaris_engine/backtracking_algorithms/n_queens.dart';
// import 'package:lunaris_engine/backtracking_algorithms/sudoku_solver.dart';
// import 'package:lunaris_engine/backtracking_algorithms/subset_generation.dart';
// import 'package:lunaris_engine/backtracking_algorithms/permutations.dart';
// import 'package:lunaris_engine/backtracking_algorithms/word_search.dart';
// import 'package:lunaris_engine/backtracking_algorithms/combinations.dart';
// import 'package:lunaris_engine/backtracking_algorithms/combination_sum.dart';
// import 'package:lunaris_engine/backtracking_algorithms/letter_combinations_phone_number.dart';
// import 'package:lunaris_engine/backtracking_algorithms/rat_in_a_maze.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  // 👑 N-Queens
  print('N-Queens (n=4):');
  for (var board in solveNQueens(4)) {
    for (var row in board) {
      print(row);
    }
    print('');
  }

  // 🧩 Sudoku Solver
  var sudoku = [
    ['5', '3', '.', '.', '7', '.', '.', '.', '.'],
    ['6', '.', '.', '1', '9', '5', '.', '.', '.'],
    ['.', '9', '8', '.', '.', '.', '.', '6', '.'],
    ['8', '.', '.', '.', '6', '.', '.', '.', '3'],
    ['4', '.', '.', '8', '.', '3', '.', '.', '1'],
    ['7', '.', '.', '.', '2', '.', '.', '.', '6'],
    ['.', '6', '.', '.', '.', '.', '2', '8', '.'],
    ['.', '.', '.', '4', '1', '9', '.', '.', '5'],
    ['.', '.', '.', '.', '8', '.', '.', '7', '9'],
  ];
  solveSudoku(sudoku);
  print('Sudoku Solved:');
  for (var row in sudoku) {
    print(row);
  }

  // 🔢 Subset Generation
  print('Subsets of [1,2,3]: ${subsets([1, 2, 3])}');

  // 🔄 Permutations
  print('Permutations of [1,2,3]: ${permutations([1, 2, 3])}');

  // 🔍 Word Search
  var board = [
    ['A', 'B', 'C', 'E'],
    ['S', 'F', 'C', 'S'],
    ['A', 'D', 'E', 'E'],
  ];
  print('Word "ABCCED" exists: ${wordSearch(board, "ABCCED")}');

  // 🔢 Combinations
  print('Combinations of 4 choose 2: ${combine(4, 2)}');

  // ➕ Combination Sum
  print(
    'Combination Sum [2,3,6,7] target 7: ${combinationSum([2, 3, 6, 7], 7)}',
  );

  // ☎️ Letter Combinations of Phone Number
  print('Letter Combinations for "23": ${letterCombinations("23")}');

  // 🐀 Rat in a Maze
  var maze = [
    [1, 0, 0, 0],
    [1, 1, 0, 1],
    [0, 1, 0, 0],
    [1, 1, 1, 1],
  ];
  print('Rat in a Maze paths: ${ratInMaze(maze)}');
}
