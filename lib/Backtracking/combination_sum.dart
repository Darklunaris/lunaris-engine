/// Finds all unique combinations of numbers that sum to a target using backtracking.
///
/// This function returns all unique combinations in [candidates] where the chosen numbers sum to [target].
/// Each number in [candidates] may be used unlimited times in a combination. The solution set does not contain duplicate combinations.
///
/// Time Complexity: O(2^n), where n is the number of candidates (worst case, exponential due to backtracking).
///
/// Example:
/// ```dart
/// var result = combinationSum([2, 3, 6, 7], 7);
/// print(result); // Outputs: [[2, 2, 3], [7]]
/// ```
List<List<int>> combinationSum(List<int> candidates, int target) {
  List<List<int>> result = [];
  void backtrack(int start, int remain, List<int> path) {
    if (remain == 0) {
      result.add(List<int>.from(path));
      return;
    }
    for (int i = start; i < candidates.length; i++) {
      if (candidates[i] > remain) continue;
      path.add(candidates[i]);
      backtrack(i, remain - candidates[i], path);
      path.removeLast();
    }
  }

  backtrack(0, target, []);
  return result;
}
