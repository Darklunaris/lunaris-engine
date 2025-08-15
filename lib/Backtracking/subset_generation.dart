/// Generates all possible subsets (the power set) of a given list using backtracking.
///
/// This function returns all possible subsets of the input list [nums], including the empty set and the set itself.
/// Each subset is represented as a list. The function uses backtracking to explore all combinations.
///
/// Time Complexity: O(2^n), where n is the length of [nums].
///
/// Example:
/// ```dart
/// var result = subsets([1, 2, 3]);
/// print(result); // Outputs: [[], [1], [1,2], [1,2,3], [1,3], [2], [2,3], [3]]
/// ```
List<List<T>> subsets<T>(List<T> nums) {
  List<List<T>> result = [];
  void backtrack(int start, List<T> path) {
    result.add(List<T>.from(path));
    for (int i = start; i < nums.length; i++) {
      path.add(nums[i]);
      backtrack(i + 1, path);
      path.removeLast();
    }
  }

  backtrack(0, []);
  return result;
}
