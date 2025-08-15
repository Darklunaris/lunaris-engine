import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final head = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
  final rotated = rotateLinkedList(head, 2);
  print('Rotate by 2 => ${LinkedListNode.toList(rotated)}');
}
