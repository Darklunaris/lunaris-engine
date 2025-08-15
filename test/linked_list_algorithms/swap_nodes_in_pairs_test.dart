import 'package:test/test.dart';
import 'package:lunaris_engine/LinkedList/linked_list_node.dart';
import 'package:lunaris_engine/LinkedList/swap_nodes_in_pairs.dart';

void main() {
  group('Swap Nodes in Pairs', () {
    test('Swaps pairs in even-length list', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4]);
      final swapped = swapNodesInPairs(head);
      expect(LinkedListNode.toList(swapped), equals([2, 1, 4, 3]));
    });
    test('Swaps pairs in odd-length list', () {
      final head = LinkedListNode.fromList([1, 2, 3, 4, 5]);
      final swapped = swapNodesInPairs(head);
      expect(LinkedListNode.toList(swapped), equals([2, 1, 4, 3, 5]));
    });
    test('Single node list', () {
      final head = LinkedListNode.fromList([42]);
      final swapped = swapNodesInPairs(head);
      expect(LinkedListNode.toList(swapped), equals([42]));
    });
    test('Empty list', () {
      final swapped = swapNodesInPairs<int>(null);
      expect(swapped, isNull);
    });
    test('Large list behavior sanity', () {
      final head = LinkedListNode.fromList(List<int>.generate(101, (i) => i));
      final swapped = swapNodesInPairs(head);
      final out = LinkedListNode.toList(swapped);
      // check pairwise swap property for first few
      expect(out[0], equals(1));
      expect(out[1], equals(0));
      expect(out.length, equals(101));
    });
    test('Idempotent for k=0-like operation (no-op semantics)', () {
      // swapNodesInPairs should be deterministic; calling twice returns original ordering for even lists
      final head = LinkedListNode.fromList([1, 2, 3, 4]);
      final once = swapNodesInPairs(head);
      final twice = swapNodesInPairs(once);
      expect(LinkedListNode.toList(twice), equals([1, 2, 3, 4]));
    });
  });
}
