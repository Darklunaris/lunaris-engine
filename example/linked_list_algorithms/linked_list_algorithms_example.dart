import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  print('🔗 Linked List Algorithms Example\n');

  // Create sample linked lists
  final list1 = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
  final list2 = LinkedListNode.fromList<int>([6, 7, 8, 9, 10]);
  final sortedList1 = LinkedListNode.fromList<int>([1, 3, 5, 7, 9]);
  final sortedList2 = LinkedListNode.fromList<int>([2, 4, 6, 8, 10]);

  print('📊 Basic Linked List Operations:');
  print('List 1: ${LinkedListNode.toList(list1)}');
  print('List 2: ${LinkedListNode.toList(list2)}');
  print('Length of List 1: ${LinkedListNode.length(list1)}');
  print('');

  // Insert and Delete Operations
  print('📍 Insert and Delete Operations:');
  var modifiedList = insertAtPosition(list1, 0, 0);
  print('Insert 0 at beginning: ${LinkedListNode.toList(modifiedList)}');

  modifiedList = insertAtPosition(modifiedList, 6, 6);
  print('Insert 6 at end: ${LinkedListNode.toList(modifiedList)}');

  modifiedList = insertAfterValue(modifiedList, 3, 35);
  print('Insert 35 after 3: ${LinkedListNode.toList(modifiedList)}');

  modifiedList = deleteAtPosition(modifiedList, 1);
  print('Delete at position 1: ${LinkedListNode.toList(modifiedList)}');

  modifiedList = deleteByValue(modifiedList, 35);
  print('Delete value 35: ${LinkedListNode.toList(modifiedList)}');
  print('');

  // Reverse Operations
  print('🔄 Reverse Operations:');
  final reversedList = reverseLinkedList(list2);
  print('Original: ${LinkedListNode.toList(list2)}');
  print('Reversed: ${LinkedListNode.toList(reversedList)}');

  final groupReversed = reverseInGroups(list1, 2);
  print('Reversed in groups of 2: ${LinkedListNode.toList(groupReversed)}');

  final betweenReversed = reverseBetween(list1, 2, 4);
  print(
    'Reversed between positions 2-4: ${LinkedListNode.toList(betweenReversed)}',
  );
  print('');

  // Cycle Detection
  print('🔍 Cycle Detection:');
  final cycleList = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
  // Create a cycle: 5 -> 3
  cycleList!.next!.next!.next!.next!.next = cycleList.next!.next;

  print('Has cycle: ${detectCycle(cycleList)}');
  print('Cycle length: ${getCycleLength(cycleList)}');

  final cycleStart = findCycleStart(cycleList);
  print('Cycle starts at: ${cycleStart?.value}');
  print('');

  // Merge Sorted Lists
  print('🔗 Merge Sorted Lists:');
  print('Sorted List 1: ${LinkedListNode.toList(sortedList1)}');
  print('Sorted List 2: ${LinkedListNode.toList(sortedList2)}');

  final mergedList = mergeSortedLists(sortedList1, sortedList2);
  print('Merged: ${LinkedListNode.toList(mergedList)}');
  print('');

  // Remove Nth from End
  print('🗑️ Remove Nth from End:');
  final testList = LinkedListNode.fromList<int>([1, 2, 3, 4, 5, 6, 7, 8]);
  print('Original: ${LinkedListNode.toList(testList)}');

  final removed2nd = removeNthFromEnd(testList, 2);
  print('Remove 2nd from end: ${LinkedListNode.toList(removed2nd)}');

  final removed1st = removeNthFromEnd(removed2nd, 1);
  print('Remove 1st from end: ${LinkedListNode.toList(removed1st)}');
  print('');

  // Palindrome Check
  print('🎭 Palindrome Check:');
  final palindromeList = LinkedListNode.fromList<int>([1, 2, 3, 2, 1]);
  final nonPalindromeList = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);

  print('List: ${LinkedListNode.toList(palindromeList)}');
  print('Is palindrome: ${isPalindrome(palindromeList)}');

  print('List: ${LinkedListNode.toList(nonPalindromeList)}');
  print('Is palindrome: ${isPalindrome(nonPalindromeList)}');
  print('');

  // Intersection of Lists
  print('🔗 Intersection of Lists:');
  final listA = LinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
  final listB = LinkedListNode.fromList<int>([9, 8, 7, 3, 4, 5]);

  // Create intersection: both lists share nodes 3, 4, 5
  final sharedNode = listA!.next!.next; // Node with value 3
  listB!.next!.next!.next = sharedNode;

  print('List A: ${LinkedListNode.toList(listA)}');
  print('List B: ${LinkedListNode.toList(listB)}');

  final intersection = getIntersectionNode(listA, listB);
  print('Intersection node: ${intersection?.value}');

  final intersectionInfo = getIntersectionNodeWithInfo(listA, listB);
  print('Intersection info: $intersectionInfo');
  print('');

  // Doubly Linked List Operations
  print('🔗🔗 Doubly Linked List Operations:');
  final doublyList = DoublyLinkedListNode.fromList<int>([1, 2, 3, 4, 5]);
  print('Doubly linked list: ${DoublyLinkedListNode.toList(doublyList)}');

  final reversedDoubly = reverseDoublyLinkedList(doublyList);
  print(
    'Reversed doubly linked list: ${DoublyLinkedListNode.toList(reversedDoubly)}',
  );
  print('');

  // Complex Operations
  print('🔄 Complex Operations:');
  var complexList = LinkedListNode.fromList<int>([
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
  ]);
  print('Original: ${LinkedListNode.toList(complexList)}');

  // Multiple operations
  complexList = insertAtPosition(complexList, 15, 1);
  complexList = insertAtPosition(complexList, 65, 7);
  print('After insertions: ${LinkedListNode.toList(complexList)}');

  complexList = reverseInGroups(complexList, 3);
  print('After group reverse (3): ${LinkedListNode.toList(complexList)}');

  complexList = removeNthFromEnd(complexList, 3);
  print('After removing 3rd from end: ${LinkedListNode.toList(complexList)}');

  final finalReversed = reverseLinkedList(complexList);
  print('Final reversed: ${LinkedListNode.toList(finalReversed)}');
  print('');

  print('');

  print('🌟 Advanced Linked List Algorithms (New):');
  // Rotate Linked List
  final rotateList = LinkedListNode.fromList([1, 2, 3, 4, 5]);
  final rotated = rotateLinkedList(rotateList, 2);
  print('Rotate Linked List by 2: ${LinkedListNode.toList(rotated)}');

  // Swap Nodes in Pairs
  final swapList = LinkedListNode.fromList([1, 2, 3, 4, 5]);
  final swapped = swapNodesInPairs(swapList);
  print('Swap Nodes in Pairs: ${LinkedListNode.toList(swapped)}');

  // Remove Duplicates from Sorted List
  final dedupList = LinkedListNode.fromList([1, 1, 2, 3, 3]);
  final deduped = removeDuplicatesSortedList(dedupList);
  print(
    'Remove Duplicates from Sorted List: ${LinkedListNode.toList(deduped)}',
  );

  // Partition List
  final partList = LinkedListNode.fromList([1, 4, 3, 2, 5, 2]);
  final partitioned = partitionList(partList, 3);
  print('Partition List around 3: ${LinkedListNode.toList(partitioned)}');

  // Sort Linked List (Merge Sort)
  final unsorted = LinkedListNode.fromList([4, 2, 1, 3]);
  final sorted = mergeSortLinkedList(unsorted);
  print('Sort Linked List (Merge Sort): ${LinkedListNode.toList(sorted)}');

  // Add Two Numbers (Linked List representation)
  final l1 = LinkedListNode.fromList([2, 4, 3]);
  final l2 = LinkedListNode.fromList([5, 6, 4]);
  final sum = addTwoNumbersLinkedList(l1, l2);
  print('Add Two Numbers: ${LinkedListNode.toList(sum)}');

  // Intersection Detection using HashSet
  final a = LinkedListNode.fromList([1, 2, 3]);
  final b = LinkedListNode.fromList([4, 5]);
  b!.next!.next = a!.next; // intersection at node with value 2
  final intersectionHash = intersectionDetectionHashSet(a, b);
  print('Intersection Detection using HashSet: ${intersectionHash?.value}');

  // Reverse Nodes in K-Group
  final kGroupList = LinkedListNode.fromList([1, 2, 3, 4, 5]);
  final kReversed = reverseNodesInKGroup(kGroupList, 2);
  print('Reverse Nodes in K-Group (k=2): ${LinkedListNode.toList(kReversed)}');

  // Detect and Remove Loop
  final loopList = LinkedListNode.fromList([1, 2, 3, 4, 5]);
  loopList!.next!.next!.next!.next!.next = loopList.next!.next; // create loop
  final foundLoop = detectAndRemoveLoop(loopList);
  print(
    'Detect and Remove Loop: $foundLoop, List: ${LinkedListNode.toList(loopList)}',
  );

  // Convert Binary Number in Linked List to Integer
  final binList = LinkedListNode.fromList([1, 0, 1]);
  final intValue = convertBinaryLinkedListToInt(binList);
  print('Convert Binary Linked List to Int: $intValue');

  print('\n✅ All linked list algorithms demonstrated successfully!');
}
