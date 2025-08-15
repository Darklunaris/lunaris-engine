/// Checks if the input [list] contains any duplicate elements.
///
/// This is a generic method that works with any type [T] that can be stored in a Set.
///
/// Returns `true` if a duplicate is found, `false` otherwise.
///
/// Time Complexity: O(n)
/// Space Complexity: O(n)
bool hasDuplicates<T>(List<T> list) {
  final Set<T> seen = <T>{};

  for (final element in list) {
    if (seen.contains(element)) {
      return true;
    }
    seen.add(element);
  }

  return false;
}
