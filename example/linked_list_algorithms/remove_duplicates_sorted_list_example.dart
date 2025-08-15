import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final head = LinkedListNode.fromList<int>([1, 1, 2, 3, 3]);
  final deduped = removeDuplicatesSortedList(head);
  print('Deduped => ${LinkedListNode.toList(deduped)}');
}
