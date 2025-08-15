import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final head = LinkedListNode.fromList<int>([1, 2, 3, 4]);
  final swapped = swapNodesInPairs(head);
  print('Swapped pairs => ${LinkedListNode.toList(swapped)}');
}
