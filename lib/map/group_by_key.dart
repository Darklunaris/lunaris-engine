/// Groups the elements of [items] using the provided [keySelector] function
/// which extracts a key of type [K] from each element of type [T].
///
/// Returns a [Map] where each key corresponds to a group of items that share that key.
///
/// Example:
/// ```dart
/// groupByKey(['apple', 'banana', 'apricot'], (word) => word[0].toUpperCase());
/// // => {'A': ['apple', 'apricot'], 'B': ['banana']}
/// ```
Map<K, List<T>> groupByKey<T, K>(List<T> items, K Function(T) keySelector) {
  final Map<K, List<T>> grouped = {};

  for (final item in items) {
    final key = keySelector(item);
    grouped.putIfAbsent(key, () => []).add(item);
  }

  return grouped;
}

Map<String, List<String>> groupByFirstLetter(List<String> words) {
  final filteredWords = words.where((w) => w.isNotEmpty).toList();

  return groupByKey<String, String>(
    filteredWords,
    (word) => word[0].toUpperCase(),
  );
}
