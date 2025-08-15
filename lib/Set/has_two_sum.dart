/// Checks if there exists a pair of elements in [nums] whose sum equals [target].
///
/// Works for numeric types only (e.g., int, double).
///
/// Example:
/// ```dart
/// hasTwoSum([2, 7, 11, 15], 9); // => true (2 + 7)
/// hasTwoSum([1, 2, 3, 4], 10);  // => false
/// ```
bool hasTwoSum<T extends num>(List<T> nums, T target) {
  final Set<T> seen = {};

  for (final num in nums) {
    final complement = (target - num) as T;
    if (seen.contains(complement)) return true;
    seen.add(num);
  }

  return false;
}
