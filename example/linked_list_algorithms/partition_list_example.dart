import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final head = LinkedListNode.fromList<int>([1, 4, 3, 2, 5, 2]);
  final partitioned = partitionList(head, 3);
  print('Partitioned around 3 => ${LinkedListNode.toList(partitioned)}');
}
