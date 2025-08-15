import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
  head!.next!.next!.next!.next!.next = head.next!.next; // create loop
  final found = detectAndRemoveLoop(head);
  print('Found and removed loop: $found');
  print('List now => ${LinkedListNode.toList(head)}');
}
