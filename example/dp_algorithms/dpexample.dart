// import 'package:lunaris_engine/dp_algorithms/fibonacci_memoization.dart';
// import 'package:lunaris_engine/dp_algorithms/knapsack_01.dart';
// import 'package:lunaris_engine/dp_algorithms/longest_increasing_subsequence.dart';
// import 'package:lunaris_engine/dp_algorithms/longest_common_subsequence.dart';
// import 'package:lunaris_engine/dp_algorithms/edit_distance.dart';
// import 'package:lunaris_engine/dp_algorithms/matrix_path_sum.dart';
// import 'package:lunaris_engine/dp_algorithms/coin_change.dart';
// import 'package:lunaris_engine/dp_algorithms/subset_sum.dart';
// import 'package:lunaris_engine/dp_algorithms/partition_equal_subset_sum.dart';
// import 'package:lunaris_engine/dp_algorithms/house_robber.dart';
// import 'package:lunaris_engine/dp_algorithms/jump_game.dart';
// import 'package:lunaris_engine/dp_algorithms/alternating_subsequences.dart';
// import 'package:lunaris_engine/dp_algorithms/rod_cutting.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  // 🧮 Fibonacci (Memoization)
  print('Fibonacci(10): ${fibonacciMemo(10)}');

  // 🎒 0/1 Knapsack
  print('Knapsack01: ${knapsack01([1, 2, 3], [6, 10, 12], 5)}');

  // 📈 Longest Increasing Subsequence
  print('LIS: ${longestIncreasingSubsequence([10, 9, 2, 5, 3, 7, 101, 18])}');

  // 🔗 Longest Common Subsequence
  print('LCS: ${longestCommonSubsequence("abcde", "ace")}');

  // ✏️ Edit Distance
  print('Edit Distance: ${editDistance("kitten", "sitting")}');

  // 🧮 Matrix Path Sum
  print(
    'Min Path Sum: ${minPathSum([
      [1, 3, 1],
      [1, 5, 1],
      [4, 2, 1],
    ])}',
  );

  // 💰 Coin Change
  print('Coin Change: ${coinChange([1, 2, 5], 11)}');

  // 🔢 Subset Sum
  print('Subset Sum: ${subsetSum([3, 34, 4, 12, 5, 2], 9)}');

  // ⚖️ Partition Equal Subset Sum
  print('Can Partition: ${canPartition([1, 5, 11, 5])}');

  // 🏠 House Robber
  print('House Robber: ${houseRobber([2, 7, 9, 3, 1])}');

  // 🏃 Jump Game
  print('Can Jump: ${canJump([2, 3, 1, 1, 4])}');

  // 🔄 Alternating Subsequences
  print(
    'Longest Alternating Subsequence: ${longestAlternatingSubsequence([1, 7, 4, 9, 2, 5])}',
  );

  // 🪚 Rod Cutting
  print('Rod Cutting: ${rodCutting([1, 5, 8, 9, 10, 17, 17, 20], 8)}');
}
