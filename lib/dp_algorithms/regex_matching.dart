/// 🔎 Regular Expression Matching (DP)
///
/// Supports '.' which matches any single character and '*' which matches zero
/// or more of the preceding element. Return true if the entire pattern matches.
///
/// Contract:
/// - Input: String s, String p
/// - Output: bool
///
/// Time Complexity: O(n*m)
/// Space Complexity: O(n*m)
///
/// Example:
/// ```dart
/// expect(isRegexMatch('aab', 'c*a*b'), isTrue);
/// ```
bool isRegexMatch(String s, String p) {
  final n = s.length;
  final m = p.length;
  final dp = List.generate(n + 1, (_) => List<bool>.filled(m + 1, false));
  dp[0][0] = true;
  for (var j = 2; j <= m; j++) {
    if (p[j - 1] == '*') dp[0][j] = dp[0][j - 2];
  }
  for (var i = 1; i <= n; i++) {
    for (var j = 1; j <= m; j++) {
      if (p[j - 1] == '.' || p[j - 1] == s[i - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      } else if (p[j - 1] == '*') {
        dp[i][j] = dp[i][j - 2];
        if (p[j - 2] == '.' || p[j - 2] == s[i - 1]) {
          dp[i][j] = dp[i][j] || dp[i - 1][j];
        }
      }
    }
  }
  return dp[n][m];
}
