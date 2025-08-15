import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  final a = LinkedListNode.fromList<int>([1, 2, 3]);
  final b = LinkedListNode.fromList<int>([4, 5]);
  b!.next!.next = a!.next; // intersection at node with value 2
  final intersection = intersectionDetectionHashSet(a, b);
  print('Intersection value => ${intersection?.value}');
}
