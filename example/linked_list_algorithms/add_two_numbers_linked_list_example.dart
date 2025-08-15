import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final l1 = LinkedListNode.fromList([2, 4, 3]);
  final l2 = LinkedListNode.fromList([5, 6, 4]);
  final sum = addTwoNumbersLinkedList(l1, l2);
  print('Sum => ${LinkedListNode.toList(sum)}');
}
