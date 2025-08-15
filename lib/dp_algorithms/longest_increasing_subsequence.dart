/// 📈 Longest Increasing Subsequence (LIS, Generic) - O(n log n)
///
/// Returns the length of the longest strictly increasing subsequence in [items].
/// Uses patience sorting (binary search) for efficiency.
/// Works for any type [T] that extends Comparable.
///
/// Example:
/// ```dart
/// longestIncreasingSubsequence([10, 9, 2, 5, 3, 7, 101, 18]); // 4
/// longestIncreasingSubsequence(['a', 'b', 'c']); // 3
/// ```
int longestIncreasingSubsequence<T extends Comparable>(List<T> items) {
  if (items.isEmpty) return 0;
  final List<T> tails = [];
  for (final item in items) {
    int left = 0, right = tails.length;
    while (left < right) {
      int mid = (left + right) >> 1;
      if (tails[mid].compareTo(item) < 0) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }
    if (left == tails.length) {
      tails.add(item);
    } else {
      tails[left] = item;
    }
  }
  return tails.length;
}
