import 'package:lunaris_engine/Set/disjoint_set.dart';
import 'package:test/test.dart';

void main() {
  group('DisjointSet', () {
    test('basic union-find operations', () {
      final ds = DisjointSet<int>();

      ds.union(1, 2);
      ds.union(2, 3);
      ds.union(4, 5);

      expect(ds.find(1), equals(ds.find(3)));
      expect(ds.find(4), equals(ds.find(5)));
      expect(ds.find(1), isNot(equals(ds.find(4))));
    });

    test('works with strings', () {
      final ds = DisjointSet<String>();

      ds.union('A', 'B');
      ds.union('C', 'D');
      ds.union('B', 'C');

      expect(ds.find('A'), equals(ds.find('D')));
    });

    test('adds elements dynamically', () {
      final ds = DisjointSet<double>();
      ds.add(1.1);
      ds.add(2.2);

      expect(ds.find(1.1), equals(1.1));
      expect(ds.find(2.2), equals(2.2));

      ds.union(1.1, 2.2);
      expect(ds.find(1.1), equals(ds.find(2.2)));
    });
  });
}
