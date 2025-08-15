/// Generates all possible combinations of k numbers out of the range 1 to n using backtracking.
///
/// This function returns a list of all unique combinations of size [k] from the numbers 1 to [n].
/// Each combination is a list of integers in ascending order. No duplicate combinations are included.
///
/// Time Complexity: O(C(n, k) * k), where C(n, k) is the binomial coefficient.
///
/// Example:
/// ```dart
/// var result = combine(4, 2);
/// print(result); // Outputs: [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
/// ```
List<List<int>> combine(int n, int k) {
  List<List<int>> result = [];
  void backtrack(int start, List<int> path) {
    if (path.length == k) {
      result.add(List<int>.from(path));
      return;
    }
    for (int i = start; i <= n; i++) {
      path.add(i);
      backtrack(i + 1, path);
      path.removeLast();
    }
  }

  backtrack(1, []);
  return result;
}
