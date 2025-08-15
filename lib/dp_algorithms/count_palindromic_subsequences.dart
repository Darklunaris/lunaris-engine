/// 🔁 Count Palindromic Substrings (DP)
///
/// Counts the number of palindromic substrings in [s]. This matches the
/// behaviour expected by the test-suite: for example, the string "aaa"
/// contains 6 palindromic substrings: 'a' (3), 'aa' (2), 'aaa' (1).
///
/// Contract:
/// - Input: non-null String s.
/// - Output: int count of palindromic substrings.
///
/// Time Complexity: O(n^2)
/// Space Complexity: O(n^2)
int countPalindromicSubsequences(String s) {
  final n = s.length;
  if (n == 0) return 0;

  // dp[i][j] is true if s[i..j] is a palindrome
  final dp = List.generate(n, (_) => List<bool>.filled(n, false));
  var count = 0;

  for (var len = 1; len <= n; len++) {
    for (var i = 0; i + len - 1 < n; i++) {
      final j = i + len - 1;
      if (s[i] == s[j]) {
        if (len <= 2) {
          dp[i][j] = true;
        } else {
          dp[i][j] = dp[i + 1][j - 1];
        }
      } else {
        dp[i][j] = false;
      }
      if (dp[i][j]) count++;
    }
  }
  return count;
}
