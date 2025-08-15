/// Returns a [Map] containing the frequency count of each unique element in [items].
///
/// Example:
/// ```dart
/// frequencyCount(['a', 'b', 'a']); // => {'a': 2, 'b': 1}
/// frequencyCount([1, 2, 2, 3]);    // => {1: 1, 2: 2, 3: 1}
/// ```
Map<T, int> frequencyCount<T>(List<T> items) {
  final Map<T, int> freqMap = {};

  for (final item in items) {
    freqMap[item] = (freqMap[item] ?? 0) + 1;
  }

  return freqMap;
}
