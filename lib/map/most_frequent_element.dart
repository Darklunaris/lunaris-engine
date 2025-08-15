/// Finds the most frequent element in a list of generic type [T].
///
/// Returns the element that appears the most times in the list.
/// If the list is empty, returns null.
///
/// Example:
/// ```dart
/// var result = mostFrequentElement<int>([1, 3, 2, 3, 4, 3, 5, 1]);
/// print(result); // Outputs: 3
/// ```
T? mostFrequentElement<T>(List<T> list) {
  if (list.isEmpty) return null;

  final Map<T, int> frequencyMap = {};

  for (var element in list) {
    frequencyMap[element] = (frequencyMap[element] ?? 0) + 1;
  }

  T mostFrequent = list[0];
  int maxCount = frequencyMap[mostFrequent]!;

  frequencyMap.forEach((key, count) {
    if (count > maxCount) {
      mostFrequent = key;
      maxCount = count;
    }
  });

  return mostFrequent;
}
