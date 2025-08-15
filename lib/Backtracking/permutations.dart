/// 🔄 Permutations (Backtracking, Generic)
///
/// Returns all possible permutations of the given list [items].
/// Works for any type [T].
///
/// - Time Complexity: O(n!)
/// - Space Complexity: O(n!)
///
/// Example:
/// ```dart
/// permutations([1,2,3]); // [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
/// permutations(['a','b']); // [['a','b'],['b','a']]
/// ```
List<List<T>> permutations<T>(List<T> items) {
  final result = <List<T>>[];
  void backtrack(List<T> path, List<T> remaining) {
    if (remaining.isEmpty) {
      result.add(List<T>.from(path));
      return;
    }
    for (int i = 0; i < remaining.length; i++) {
      path.add(remaining[i]);
      final next = List<T>.from(remaining)..removeAt(i);
      backtrack(path, next);
      path.removeLast();
    }
  }

  backtrack([], items);
  return result;
}
