/// Finds the length of the longest alternating (up/down) subsequence in a list using dynamic programming.
///
/// This function returns the length of the longest subsequence in [nums] where the elements alternately increase and decrease.
/// The subsequence does not need to be contiguous. Runs in linear time and constant space.
///
/// Time Complexity: O(n), where n is the length of [nums].
/// Space Complexity: O(1)
///
/// Example:
/// ```dart
/// var result = longestAlternatingSubsequence([1, 5, 4]);
/// print(result); // Outputs: 3 ([1,5,4])
/// ```
int longestAlternatingSubsequence(List<int> nums) {
  if (nums.isEmpty) return 0;
  int up = 1, down = 1;
  for (int i = 1; i < nums.length; i++) {
    if (nums[i] > nums[i - 1]) {
      up = down + 1;
    } else if (nums[i] < nums[i - 1]) {
      down = up + 1;
    }
  }
  return up > down ? up : down;
}
