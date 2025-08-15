import 'package:test/test.dart';
import 'package:lunaris_engine/Set/multiset_operations.dart';

void main() {
  test('MultiSet add, count, remove', () {
    final bag = MultiSet<String>(['a', 'b', 'a']);
    expect(bag.count('a'), 2);
    expect(bag.count('b'), 1);
    bag.add('a');
    expect(bag.count('a'), 3);
    bag.remove('a', 2);
    expect(bag.count('a'), 1);
    bag.remove('a');
    expect(bag.count('a'), 0);
  });

  test('MultiSet union', () {
    final a = MultiSet<int>([1, 2, 2]);
    final b = MultiSet<int>([2, 3]);
    final u = a.union(b);
    expect(u.count(1), 1);
    expect(u.count(2), 3);
    expect(u.count(3), 1);
  });

  test('MultiSet intersection', () {
    final a = MultiSet<int>([1, 2, 2]);
    final b = MultiSet<int>([2, 2, 3]);
    final i = a.intersection(b);
    expect(i.count(2), 2);
    expect(i.count(1), 0);
    expect(i.count(3), 0);
  });

  test('MultiSet difference', () {
    final a = MultiSet<int>([1, 2, 2, 3]);
    final b = MultiSet<int>([2, 3]);
    final d = a.difference(b);
    expect(d.count(1), 1);
    expect(d.count(2), 1);
    expect(d.count(3), 0);
  });
}
