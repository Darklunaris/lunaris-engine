import 'package:lunaris_engine/map/lru_cache.dart';
import 'package:test/test.dart';

void main() {
  group('LRUCache Tests', () {
    test('Put and Get basic operations', () {
      final cache = LRUCache<String, int>(2);

      cache.put('a', 1);
      cache.put('b', 2);
      expect(cache.get('a'), 1);
      expect(cache.get('b'), 2);
    });

    test('Evicts least recently used item on capacity overflow', () {
      final cache = LRUCache<String, int>(2);

      cache.put('a', 1);
      cache.put('b', 2);
      cache.get('a'); // access 'a' to mark recently used
      cache.put('c', 3); // should evict 'b'

      expect(cache.get('a'), 1);
      expect(cache.get('b'), isNull);
      expect(cache.get('c'), 3);
    });

    test('Updating an existing key changes its recency', () {
      final cache = LRUCache<String, int>(2);

      cache.put('a', 1);
      cache.put('b', 2);
      cache.put('a', 10); // update 'a', makes it most recently used
      cache.put('c', 3); // should evict 'b'

      expect(cache.get('a'), 10);
      expect(cache.get('b'), isNull);
      expect(cache.get('c'), 3);
    });

    test('Returns null for missing keys', () {
      final cache = LRUCache<String, int>(2);
      expect(cache.get('x'), isNull);
    });
  });
}
