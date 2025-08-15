import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final head = LinkedListNode.fromList<int>([4, 2, 1, 3]);
  final sorted = mergeSortLinkedList(head);
  print('Sorted => ${LinkedListNode.toList(sorted)}');
}
