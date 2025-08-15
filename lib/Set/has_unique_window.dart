/// Checks whether there exists a subwindow of length [k] in [nums]
/// such that all its elements are unique.
///
/// The function uses a sliding window and a HashSet to detect duplicates efficiently.
///
/// Example:
/// ```dart
/// hasUniqueWindow([1, 2, 3, 1, 4, 5], 3); // => true
/// hasUniqueWindow([1, 1, 1, 1], 2);      // => false
/// ```
bool hasUniqueWindow<T>(List<T> nums, int k) {
  if (nums.length < k) return false;

  final Set<T> window = {};
  int left = 0;

  for (int right = 0; right < nums.length; right++) {
    final current = nums[right];

    while (window.contains(current)) {
      window.remove(nums[left]);
      left++;
    }

    window.add(current);

    if (window.length == k) return true;
  }

  return false;
}
