/// Finds two indices in the list [nums] whose elements sum up to [target].
///
/// This function works with generic type [T] where `==` and subtraction are supported.
/// However, Dart currently does not support operator constraints on generics,
/// so this implementation assumes [T] is `int` or a similar numeric type.
///
/// Returns a list containing the two indices if such a pair exists, otherwise returns null.
///
/// Example:
/// ```dart
/// var result = twoSum<int>([2, 7, 11, 15], 9);
/// print(result); // Outputs: [0, 1]
/// ```
List<int>? twoSum<T>(List<T> nums, T target) {
  final Map<T, int> numToIndex = {};

  for (int i = 0; i < nums.length; i++) {
    T current = nums[i];

    // Dart doesn't support arithmetic operators in generics directly,
    // so to make this generic, you'd need additional mechanisms or restrict to int.
    // For now, we cast to dynamic and rely on runtime.
    dynamic complement = (target as dynamic) - (current as dynamic);

    if (numToIndex.containsKey(complement)) {
      return [numToIndex[complement]!, i];
    }

    numToIndex[current] = i;
  }

  return null;
}
