/// Returns the intersection between two lists of type [T].
///
/// The result contains all items that exist in both [list1] and [list2].
/// The order of the output matches the order of appearance in [list2].
///
/// Example:
/// ```dart
/// findIntersection([1, 2, 3], [2, 3, 4]); // => [2, 3]
/// ```
List<T> findIntersection<T>(List<T> list1, List<T> list2) {
  final Set<T> set1 = Set.from(list1);
  final List<T> intersection = [];

  for (final element in list2) {
    if (set1.contains(element)) {
      intersection.add(element);
    }
  }

  return intersection;
}
