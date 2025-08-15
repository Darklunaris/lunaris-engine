/// Solves the coin change problem using dynamic programming to find the minimum number of coins needed for a given amount.
///
/// This function returns the minimum number of coins required to make up [amount] using the denominations in [coins].
/// If it is not possible to make up the amount, returns -1. Uses a bottom-up DP approach.
///
/// Time Complexity: O(amount * n), where n is the number of coin denominations.
/// Space Complexity: O(amount)
///
/// Example:
/// ```dart
/// var result = coinChange([1, 2, 5], 11);
/// print(result); // Outputs: 3 (11 = 5 + 5 + 1)
/// ```
int coinChange(List<int> coins, int amount) {
  final dp = List<int>.filled(amount + 1, amount + 1);
  dp[0] = 0;
  for (final coin in coins) {
    for (int x = coin; x <= amount; x++) {
      if (dp[x - coin] + 1 < dp[x]) {
        dp[x] = dp[x - coin] + 1;
      }
    }
  }
  return dp[amount] > amount ? -1 : dp[amount];
}
