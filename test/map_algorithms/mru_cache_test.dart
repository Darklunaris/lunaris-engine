import 'package:test/test.dart';
import 'package:lunaris_engine/map/mru_cache.dart';

void main() {
  test('MRUCache basic', () {
    final mru = MRUCache<String, int>(2);
    mru.put('a', 1);
    mru.put('b', 2);
    expect(mru.get('a'), 1);
    mru.put('c', 3);
    expect(mru.get('b'), isNull);
    expect(mru.get('c'), 3);
    expect(mru.get('a'), 1);
  });
}
