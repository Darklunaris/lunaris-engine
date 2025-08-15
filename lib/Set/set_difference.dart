/// Returns a list of elements that are in [listA] but not in [listB].
///
/// The order of elements in the result matches their order in [listA].
///
/// Example:
/// ```dart
/// setDifference([1, 2, 3], [2, 4]); // => [1, 3]
/// ```
List<T> setDifference<T>(List<T> listA, List<T> listB) {
  final Set<T> setB = Set<T>.from(listB);
  final List<T> difference = [];

  for (final element in listA) {
    if (!setB.contains(element)) {
      difference.add(element);
    }
  }

  return difference;
}
