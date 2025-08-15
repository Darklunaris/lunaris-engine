/// * Wildcard Matching (DP)
///
/// Implements pattern matching where ? matches any single character and *
/// matches any sequence (including empty). Return true if the pattern matches
/// the entire string.
///
/// Contract:
/// - Input: String s, String p (pattern)
/// - Output: bool
///
/// Time Complexity: O(n*m)
/// Space Complexity: O(n*m)
///
/// Example:
/// ```dart
/// expect(isWildcardMatch('aa', 'a*'), isTrue);
/// ```
bool isWildcardMatch(String s, String p) {
  final n = s.length;
  final m = p.length;
  final dp = List.generate(n + 1, (_) => List<bool>.filled(m + 1, false));
  dp[0][0] = true;
  for (var j = 1; j <= m; j++) {
    if (p[j - 1] == '*') dp[0][j] = dp[0][j - 1];
  }
  for (var i = 1; i <= n; i++) {
    for (var j = 1; j <= m; j++) {
      if (p[j - 1] == s[i - 1] || p[j - 1] == '?') {
        dp[i][j] = dp[i - 1][j - 1];
      } else if (p[j - 1] == '*') {
        dp[i][j] = dp[i][j - 1] || dp[i - 1][j];
      }
    }
  }
  return dp[n][m];
}
