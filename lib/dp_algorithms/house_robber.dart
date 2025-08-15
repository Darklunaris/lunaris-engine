/// 🏠 House Robber (Dynamic Programming)
///
/// Returns the maximum amount that can be robbed without robbing adjacent houses.
///
/// Time Complexity: O(n)
/// Space Complexity: O(1)
int houseRobber(List<int> nums) {
  int prev1 = 0, prev2 = 0;
  for (final num in nums) {
    final temp = prev1;
    prev1 = (prev2 + num > prev1) ? prev2 + num : prev1;
    prev2 = temp;
  }
  return prev1;
}
