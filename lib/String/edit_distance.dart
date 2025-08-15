/// Computes the Edit Distance (Levenshtein Distance) between two strings.
///
/// This distance represents the minimum number of operations
/// (insertions, deletions, or substitutions) required to convert
/// word1 into word2.
///
/// Example:
/// ```dart
/// print(editDistance("horse", "ros")); // Output: 3
/// ```
int editDistance(String word1, String word2) {
  final int m = word1.length;
  final int n = word2.length;

  // Initialize DP table with size (m+1) x (n+1)
  List<List<int>> dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

  // Base cases: transforming empty string to word2 by inserting chars
  for (int j = 0; j <= n; j++) {
    dp[0][j] = j;
  }

  // Base cases: transforming word1 to empty string by deleting chars
  for (int i = 0; i <= m; i++) {
    dp[i][0] = i;
  }

  // Fill DP table
  for (int i = 1; i <= m; i++) {
    for (int j = 1; j <= n; j++) {
      if (word1[i - 1] == word2[j - 1]) {
        // Characters match, no operation needed
        dp[i][j] = dp[i - 1][j - 1];
      } else {
        // Minimum of insert, delete, replace operations + 1
        dp[i][j] = [
          dp[i][j - 1] + 1, // Insert
          dp[i - 1][j] + 1, // Delete
          dp[i - 1][j - 1] + 1, // Replace
        ].reduce((a, b) => a < b ? a : b);
      }
    }
  }

  return dp[m][n];
}
