/// 🧮 Fibonacci with Memoization (Dynamic Programming)
///
/// Efficiently computes the nth Fibonacci number using top-down DP with memoization.
///
/// Time Complexity: O(n)
/// Space Complexity: O(n)
int fibonacciMemo(int n, [Map<int, int>? memo]) {
  memo ??= <int, int>{};
  if (n <= 1) return n;
  if (memo.containsKey(n)) return memo[n]!;
  memo[n] = fibonacciMemo(n - 1, memo) + fibonacciMemo(n - 2, memo);
  return memo[n]!;
}
