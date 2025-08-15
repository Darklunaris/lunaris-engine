/// Checks if the frequencies of elements in the list are all unique.
///
/// Returns `true` if no two elements have the same frequency.
///
/// Example:
/// ```dart
/// isFrequencyUnique([1, 2, 2, 3, 3, 3]); // => true
/// isFrequencyUnique([1, 2, 2, 3, 3]);    // => false
/// ```
bool isFrequencyUnique<T>(List<T> list) {
  final Map<T, int> freqMap = {};
  for (final element in list) {
    freqMap[element] = (freqMap[element] ?? 0) + 1;
  }

  final Set<int> freqSet = {};
  for (final freq in freqMap.values) {
    if (!freqSet.add(freq)) return false;
  }

  return true;
}
