import 'dart:collection';

/// A generic implementation of an LRU (Least Recently Used) Cache.
///
/// The cache holds a limited number of key-value pairs up to [capacity].
/// When the capacity is reached, the least recently accessed item is evicted.
///
/// Uses a [LinkedHashMap] to maintain insertion order and update on access.
///
/// Example:
/// ```dart
/// final cache = LRUCache<String, int>(3);
/// cache.put('a', 1);
/// cache.put('b', 2);
/// cache.get('a'); // Access 'a' to make it most recently used
/// cache.put('c', 3);
/// cache.put('d', 4); // This will evict 'b' as least recently used
/// ```
class LRUCache<K, V> {
  final int capacity;
  final _cache = <K, V>{};

  /// Creates an LRU cache with the given [capacity].
  LRUCache(this.capacity);

  /// Returns the value associated with [key] if present,
  /// and marks the entry as most recently used.
  /// Returns `null` if [key] is not found.
  V? get(K key) {
    if (!_cache.containsKey(key)) return null;

    // Remove and re-insert to update usage order.
    V value = _cache.remove(key) as V;
    _cache[key] = value;
    return value;
  }

  /// Inserts or updates the [key] with [value].
  /// If the cache exceeds [capacity], evicts the least recently used entry.
  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    }
    if (_cache.length >= capacity) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  /// Prints the current cache content (for debugging).
  void printCache() {
    print('Current cache state:');
    _cache.forEach((key, value) {
      print('  $key: $value');
    });
    print('----------------------');
  }
}
