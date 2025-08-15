/// 🔺 Longest Bitonic Subsequence (DP)
///
/// Find the length of the longest subsequence which first strictly increases
/// then strictly decreases. A single increasing or decreasing run counts as
/// bitonic as well (peak at an end).
///
/// Contract:
/// - Input: List<int> (may be empty).
/// - Output: int length of the longest bitonic subsequence.
///
/// Time Complexity: O(n^2)
/// Space Complexity: O(n)
///
/// Example:
/// ```dart
/// final arr = [1,11,2,10,4,5,2,1];
/// expect(longestBitonicSubsequence(arr), equals(6));
/// ```
int longestBitonicSubsequence(List<int> arr) {
  final n = arr.length;
  if (n == 0) return 0;
  final lis = List<int>.filled(n, 1);
  final lds = List<int>.filled(n, 1);

  for (var i = 0; i < n; i++) {
    for (var j = 0; j < i; j++) {
      if (arr[j] < arr[i] && lis[j] + 1 > lis[i]) lis[i] = lis[j] + 1;
    }
  }

  for (var i = n - 1; i >= 0; i--) {
    for (var j = n - 1; j > i; j--) {
      if (arr[j] < arr[i] && lds[j] + 1 > lds[i]) lds[i] = lds[j] + 1;
    }
  }

  var best = 0;
  for (var i = 0; i < n; i++) {
    final len = lis[i] + lds[i] - 1;
    if (len > best) best = len;
  }
  return best;
}
