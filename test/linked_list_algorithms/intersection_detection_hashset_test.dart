import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/intersection_detection_hashset.dart';

void main() {
  group('Intersection Detection using HashSet', () {
    test('Detects intersection', () {
      final a = LinkedListNode.fromList([1, 2, 3]);
      final b = LinkedListNode.fromList([4, 5]);
      b!.next!.next = a!.next; // intersection at node with value 2
      final intersection = intersectionDetectionHashSet(a, b);
      expect(intersection, equals(a.next));
    });
    test('No intersection', () {
      final a = LinkedListNode.fromList([1, 2, 3]);
      final b = LinkedListNode.fromList([4, 5, 6]);
      final intersection = intersectionDetectionHashSet(a, b);
      expect(intersection, isNull);
    });
    test('One list is null', () {
      final a = LinkedListNode.fromList([1, 2, 3]);
      final intersection = intersectionDetectionHashSet(a, null);
      expect(intersection, isNull);
    });
    test('Both lists are null', () {
      final intersection = intersectionDetectionHashSet<int>(null, null);
      expect(intersection, isNull);
    });
    test('Intersection when one list is contained', () {
      final a = LinkedListNode.fromList([1, 2, 3, 4]);
      final b = a!.next!.next; // list b is a suffix starting at 3
      final intersection = intersectionDetectionHashSet(a, b);
      expect(intersection, equals(b));
    });

    test('Both lists null returns null', () {
      final intersection = intersectionDetectionHashSet<int>(null, null);
      expect(intersection, isNull);
    });
  });
}
