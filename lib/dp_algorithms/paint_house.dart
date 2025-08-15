/// 🏠 Paint House (DP)
///
/// Given a list of painting costs where costs[i][j] is the cost of painting
/// house `i` with color `j` (0..2), compute the minimum total cost such
/// that no two adjacent houses have the same color.
///
/// Contract:
/// - Input: non-null List<List<int>> where each inner list has length 3.
/// - Output: non-negative int representing the minimum painting cost.
///
/// Time Complexity: O(n)
/// Space Complexity: O(1)
///
/// Example:
/// ```dart
/// final costs = [
///   [17,2,17],
///   [16,16,5],
///   [14,3,19]
/// ];
/// expect(minCostPaintHouse(costs), equals(10));
/// ```
int minCostPaintHouse(List<List<int>> costs) {
  if (costs.isEmpty) return 0;
  final n = costs.length;
  for (final row in costs) {
    if (row.length != 3) {
      throw ArgumentError('Each house must have exactly 3 color costs');
    }
  }

  int a = costs[0][0];
  int b = costs[0][1];
  int c = costs[0][2];

  for (var i = 1; i < n; i++) {
    final na = costs[i][0] + (b < c ? b : c);
    final nb = costs[i][1] + (a < c ? a : c);
    final nc = costs[i][2] + (a < b ? a : b);
    a = na;
    b = nb;
    c = nc;
  }

  return [a, b, c].reduce((v, e) => v < e ? v : e);
}
