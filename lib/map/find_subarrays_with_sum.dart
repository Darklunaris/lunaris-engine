/// Finds all subarrays whose sum equals the target using prefix sum and a map.
///
/// This function returns a list of index pairs [start, end] for all subarrays in [nums] that sum to [target].
/// Uses a prefix sum and a map to efficiently find all such subarrays.
///
/// Time Complexity: O(n), where n is the length of the list.
///
/// Example:
/// ```dart
/// var result = findSubarraysWithSum([1, 2, 3, 2, 1], 3);
/// print(result); // Outputs: [[0, 1], [2, 2], [3, 4]]
/// ```
List<List<int>> findSubarraysWithSum(List<int> nums, int target) {
  final result = <List<int>>[];
  final sumToIndices = <int, List<int>>{
    0: [-1],
  };
  var sum = 0;
  for (var i = 0; i < nums.length; i++) {
    sum += nums[i];
    final rem = sum - target;
    if (sumToIndices.containsKey(rem)) {
      for (final start in sumToIndices[rem]!) {
        result.add([start + 1, i]);
      }
    }
    sumToIndices.putIfAbsent(sum, () => []).add(i);
  }
  return result;
}
