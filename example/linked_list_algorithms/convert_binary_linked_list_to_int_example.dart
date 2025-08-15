import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final head = LinkedListNode.fromList([1, 0, 1]);
  final value = convertBinaryLinkedListToInt(head);
  print('Binary [1,0,1] => $value');
}
