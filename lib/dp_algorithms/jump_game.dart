/// 🏃 Jump Game (Dynamic Programming / Greedy)
///
/// Returns true if you can reach the last index from the first index in [nums].
/// Each element in [nums] represents your maximum jump length at that position.
///
/// Time Complexity: O(n)
/// Space Complexity: O(1)
bool canJump(List<int> nums) {
  int maxReach = 0;
  for (int i = 0; i < nums.length; i++) {
    if (i > maxReach) return false;
    maxReach = (i + nums[i] > maxReach) ? i + nums[i] : maxReach;
    if (maxReach >= nums.length - 1) return true;
  }
  return true;
}
