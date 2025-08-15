/// 🪙 Minimum Coin Change (Bottom-Up)
///
/// Returns the minimum number of coins needed to make up `amount` using given
/// coin denominations. Bottom-up DP with O(amount * k) time where k = coins.length.
///
/// Contract:
/// - Inputs: list of positive coin denominations and non-negative amount.
/// - Output: minimum number of coins or -1 if amount cannot be formed.
/// - Error modes: invalid coin values (<=0) are not accepted.
///
/// Example:
/// ```dart
/// coinChangeBottomUp([1,2,5], 11); // 3
/// ```
int coinChangeBottomUp(List<int> coins, int amount) {
  if (amount == 0) return 0;
  if (coins.isEmpty) return -1;
  final dp = List<int>.filled(amount + 1, amount + 1);
  dp[0] = 0;
  for (int i = 1; i <= amount; i++) {
    for (final c in coins) {
      if (c <= 0) throw ArgumentError('coin denominations must be positive');
      if (i - c >= 0) dp[i] = dp[i] < dp[i - c] + 1 ? dp[i] : dp[i - c] + 1;
    }
  }
  return dp[amount] > amount ? -1 : dp[amount];
}
