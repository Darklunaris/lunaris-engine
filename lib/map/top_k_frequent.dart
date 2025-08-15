/// Returns the top K most frequent elements in the list [items].
///
/// Works with any type [T] that supports equality and hashing.
/// Returns a list of up to K elements with the highest frequency.
///
/// Example:
/// ```dart
/// var result = topKFrequent<int>([1, 1, 1, 2, 2, 3, 3, 3, 3], 2);
/// print(result); // Outputs: [3, 1]
/// ```
List<T> topKFrequent<T>(List<T> items, int k) {
  final Map<T, int> frequencyMap = {};

  for (var item in items) {
    frequencyMap[item] = (frequencyMap[item] ?? 0) + 1;
  }

  final entries = frequencyMap.entries.toList();

  entries.sort((a, b) => b.value.compareTo(a.value));

  final topK = <T>[];
  for (int i = 0; i < k && i < entries.length; i++) {
    topK.add(entries[i].key);
  }

  return topK;
}
