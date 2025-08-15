/// 🪚 Rod Cutting (Dynamic Programming)
///
/// Given a rod of length [n] and a list of [prices] where prices[i] is the price of a rod of length i+1,
/// returns the maximum revenue obtainable by cutting up the rod and selling the pieces.
///
/// Time Complexity: O(n^2)
/// Space Complexity: O(n)
int rodCutting(List<int> prices, int n) {
  if (n == 0 || prices.isEmpty) return 0;
  final dp = List<int>.filled(n + 1, 0);
  for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= i; j++) {
      if (j - 1 < prices.length) {
        dp[i] =
            (dp[i] > prices[j - 1] + dp[i - j])
                ? dp[i]
                : prices[j - 1] + dp[i - j];
      }
    }
  }
  return dp[n];
}
