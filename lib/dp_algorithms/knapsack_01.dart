/// 🎒 0/1 Knapsack Problem (Dynamic Programming)
///
/// Solves the 0/1 Knapsack problem using bottom-up DP.
///
/// [weights] and [values] must have the same length.
/// [capacity] is the maximum weight the knapsack can carry.
/// Returns the maximum value achievable.
int knapsack01(List<int> weights, List<int> values, int capacity) {
  final n = weights.length;
  final dp = List.generate(n + 1, (_) => List<int>.filled(capacity + 1, 0));

  for (int i = 1; i <= n; i++) {
    for (int w = 0; w <= capacity; w++) {
      if (weights[i - 1] <= w) {
        dp[i][w] =
            (values[i - 1] + dp[i - 1][w - weights[i - 1]]).compareTo(
                      dp[i - 1][w],
                    ) >
                    0
                ? values[i - 1] + dp[i - 1][w - weights[i - 1]]
                : dp[i - 1][w];
      } else {
        dp[i][w] = dp[i - 1][w];
      }
    }
  }
  return dp[n][capacity];
}
