/// ✂️ Minimum Cuts for Palindrome Partitioning (DP)
///
/// Given a string s, partition s into substrings so that every substring is a
/// palindrome. Return the minimum number of cuts needed.
///
/// Contract:
/// - Input: non-null String s.
/// - Output: int minimum cuts (0 for already-palindromic string).
///
/// Time Complexity: O(n^2)
/// Space Complexity: O(n^2)
///
/// Example:
/// ```dart
/// expect(minCutsPalindromePartition('aab'), equals(1));
/// ```
int minCutsPalindromePartition(String s) {
  final n = s.length;
  if (n <= 1) return 0;
  final isPal = List.generate(n, (_) => List<bool>.filled(n, false));
  for (var i = 0; i < n; i++) {
    isPal[i][i] = true;
  }
  for (var len = 2; len <= n; len++) {
    for (var i = 0; i + len - 1 < n; i++) {
      final j = i + len - 1;
      if (s[i] == s[j] && (len == 2 || isPal[i + 1][j - 1])) isPal[i][j] = true;
    }
  }
  final cuts = List<int>.filled(n, 0);
  for (var i = 0; i < n; i++) {
    if (isPal[0][i]) {
      cuts[i] = 0;
      continue;
    }
    var best = 1 << 62;
    for (var j = 0; j < i; j++) {
      if (isPal[j + 1][i] && cuts[j] + 1 < best) best = cuts[j] + 1;
    }
    cuts[i] = best;
  }
  return cuts[n - 1];
}
