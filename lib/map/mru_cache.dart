/// Implements a Most Recently Used (MRU) Cache with fixed capacity.
///
/// The MRU cache stores key-value pairs up to a given [capacity]. When the cache is full and a new item is added,
/// it evicts the least recently used item. Accessing or inserting a key moves it to the most recently used position.
///
/// Time Complexity: O(1) for get and put operations.
///
/// Example:
/// ```dart
/// final cache = MRUCache<String, int>(2);
/// cache.put('a', 1);
/// cache.put('b', 2);
/// cache.get('a'); // Access 'a', now 'b' is least recently used
/// cache.put('c', 3); // Evicts 'b'
/// print(cache); // Outputs: {a: 1, c: 3}
/// ```
class MRUCache<K, V> {
  final int capacity;
  final _cache = <K, V>{};
  final _order = <K>[];

  MRUCache(this.capacity);

  V? get(K key) {
    if (!_cache.containsKey(key)) return null;
    _order.remove(key);
    _order.add(key);
    return _cache[key];
  }

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _order.remove(key);
    } else if (_cache.length == capacity) {
      final oldest = _order.removeAt(0);
      _cache.remove(oldest);
    }
    _cache[key] = value;
    _order.add(key);
  }

  @override
  String toString() => _cache.toString();
}
