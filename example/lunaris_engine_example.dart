// Import the umbrella library to access all algorithms
import 'package:lunaris_engine/lunaris_engine.dart'; //  import 'package:lunaris_engine/graph_algorithms/weighted_edge.dart';

// Add this function if not already defined or imported
int binaryTreeDiameter(BinaryTreeNode root) {
  int diameter = 0;

  int depth(BinaryTreeNode? node) {
    if (node == null) return 0;
    int left = depth(node.left);
    int right = depth(node.right);
    diameter = diameter > (left + right) ? diameter : (left + right);
    return 1 + (left > right ? left : right);
  }

  depth(root);
  return diameter;
}

void main() {
  // =========================
  // List Algorithms
  // =========================
  final numbers = <int>[1, 3, 5, 7, 9, 11, 13];
  final index = binarySearch<int>(numbers, 7);
  print('Binary Search: 7 at index -> $index');

  final unsorted = <int>[4, 2, 5, 1, 3];
  bubbleSort(unsorted);
  print('Bubble Sort: $unsorted');

  final listForQuick = <int>[10, 7, 8, 9, 1, 5];
  quickSort<int>(listForQuick, 0, listForQuick.length - 1);
  print('Quick Sort: $listForQuick');

  final mergeSorted = mergeSort<int>([5, 2, 4, 6, 1, 3]);
  print('Merge Sort: $mergeSorted');

  final inserted = <int>[5, 2, 9, 1, 5, 6];
  insertionSort(inserted);
  print('Insertion Sort: $inserted');

  final selected = <int>[64, 25, 12, 22, 11];
  selectionSort(selected);
  print('Selection Sort: $selected');

  final counted = countingSort([4, 2, 2, 8, 3, 3, 1]);
  print('Counting Sort: $counted');

  final idx = linearSearch([10, 20, 30, 40], 30);
  print('Linear Search: 30 at index -> $idx');

  final toReverse = [1, 2, 3, 4];
  reverseList(toReverse);
  print('Reverse List: $toReverse');

  print('Find Max: ${findMax([3, 1, 4, 1, 5])}');
  print('Find Min: ${findMin([3, 1, 4, 1, 5])}');

  print('Find Duplicates: ${findDuplicates([1, 2, 2, 3, 3, 3])}');

  print(
    'Kadane\'s Max Subarray Sum: ${kadanesAlgorithm([-2.0, 1.0, -3.0, 4.0, -1.0, 2.0, 1.0, -5.0, 4.0])}',
  );

  print(
    'Max Sum (k=3): ${maxSumSubarrayOfSizeK([2.0, 1.0, 5.0, 1.0, 3.0, 2.0], 3)}',
  );
  print(
    'Min Sum (k=3): ${minSumSubarrayOfSizeK([4, 2, 1, 7, 8, 1, 2, 8, 1, 0], 3)}',
  );

  print(
    'Average of size k=5: ${averageOfSubarraysOfSizeK([1, 3, 2, 6, -1, 4, 1, 8, 2], 5)}',
  );

  print(
    'Two Sum Sorted (target 10): ${twoSumSorted([1, 2, 3, 4, 6, 8, 11, 15], 10)}',
  );
  print('Remove Duplicates: ${removeDuplicates([1, 2, 2, 3, 3, 4])}');
  print('Rotate Right by 2: ${rotateArrayRight([1, 2, 3, 4, 5], 2)}');

  final prefix = computePrefixSum([2, 4, 1, 3, 6]);
  print('Prefix Sum: $prefix, range(1..3): ${rangeSum(prefix, 1, 3)}');

  // =========================
  // Set Algorithms
  // =========================
  print('Has Duplicates: ${hasDuplicates([1, 2, 3, 3])}');
  print('Intersection: ${findIntersection([1, 2, 3], [2, 3, 4])}');
  print('Set Difference: ${setDifference([1, 2, 3], [2, 4])}');
  print('Is Frequency Unique: ${isFrequencyUnique([1, 1, 2, 2, 3])}');
  print('Has Two Sum (target 9): ${hasTwoSum([2, 7, 11, 15], 9)}');
  print('Has Unique Window (k=3): ${hasUniqueWindow([1, 2, 3, 1, 4], 3)}');

  // =========================
  // Map Algorithms
  // =========================
  print('Frequency Count: ${frequencyCount(['a', 'b', 'a'])}');
  print(
    'Group By First Letter: ${groupByFirstLetter(['apple', 'banana', 'apricot'])}',
  );
  print('First Non-Repeated: ${firstNonRepeatedElement(['a', 'a', 'b', 'c'])}');
  print('Anagram (list): ${isAnagram<String>(['Listen'], ['Silent'])}');
  print('Two Sum (indices): ${twoSum<int>([2, 7, 11, 15], 9)}');
  final lru =
      LRUCache<String, int>(2)
        ..put('x', 1)
        ..put('y', 2)
        ..get('x')
        ..put('z', 3);
  lru.printCache();
  print('Most Frequent: ${mostFrequentElement([1, 2, 2, 3])}');
  print('Top K Frequent: ${topKFrequent([1, 1, 1, 2, 2, 3], 2)}');
  print('Length of Longest Substring: ${lengthOfLongestSubstring('abcabcbb')}');

  // =========================
  // String Algorithms
  // =========================
  print('Reverse String: ${reverseString('dart')}');
  print('Palindromes: ${isPalindromes('A man a plan a canal Panama')}');
  print('String Anagram: ${areAnagrams('listen', 'silent')}');
  print('Longest Palindromic Substring: ${longestPalindrome('babad')}');
  print('String Compression: ${compressString('aaabbc')}');
  print('Brute Force Search: ${bruteForceSearch('hello world', 'world')}');
  print('KMP Search: ${kmpSearch('abxabcabcaby', 'abcaby')}');
  print('Rabin-Karp Search: ${rabinKarpSearch('hello world', 'world')}');
  print(
    'Longest Common Prefix: ${longestCommonPrefix(['flower', 'flow', 'flight'])}',
  );
  print('Edit Distance: ${editDistance('horse', 'ros')}');
  print('Vowels/Consonants: ${countVowelsAndConsonants('Hello World!')}');

  // =========================
  // Graph Algorithms
  // =========================
  final gUnweighted = <String, List<String>>{
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': ['F'],
    'D': [],
    'E': ['F'],
    'F': [],
  };
  print('BFS: ${bfs(gUnweighted, 'A')}');
  print('DFS: ${dfs(gUnweighted, 'A')}');
  print(
    'Topological Sort (DAG): ${topologicalSort(<int, List<int>>{
      1: [2],
      2: [3],
      3: [4],
      4: [],
    })}',
  );
  print(
    'Connected Components: ${connectedComponents({
      'A': ['B'],
      'B': ['A'],
      'C': [],
    })}',
  );
  print(
    'Has Cycle Directed: ${hasCycleDirected(<int, List<int>>{
      1: [2],
      2: [3],
      3: [1],
    })}',
  );
  print(
    'Has Cycle Undirected: ${hasCycleUndirected({
      'A': ['B', 'C'],
      'B': ['A', 'C'],
      'C': ['A', 'B'],
    })}',
  );
  print(
    'Is Bipartite: ${isBipartite({
      1: [2, 4],
      2: [1, 3],
      3: [2, 4],
      4: [1, 3],
    })}',
  );
  print(
    'Shortest Path (unweighted): ${shortestPathUnweighted(gUnweighted, 'A', 'F')}',
  );

  final weighted = <String, List<WeightedEdge<String>>>{
    'A': [WeightedEdge('A', 'B', 1), WeightedEdge('A', 'C', 4)],
    'B': [WeightedEdge('B', 'C', 2), WeightedEdge('B', 'D', 5)],
    'C': [WeightedEdge('C', 'D', 1)],
    'D': [],
  };
  print('Dijkstra distances: ${dijkstra(weighted, 'A')}');

  final nodes = {'A', 'B', 'C', 'D'};
  final edges = <WeightedEdge<String>>[
    WeightedEdge('A', 'B', 1),
    WeightedEdge('B', 'C', 2),
    WeightedEdge('A', 'C', 4),
    WeightedEdge('C', 'D', 1),
  ];
  print('Bellman-Ford distances: ${bellmanFord(nodes, edges, 'A')}');
  print('Floyd-Warshall A->C: ${floydWarshall(nodes, edges)['A']!['C']}');

  final mstKruskal = kruskalMST(nodes, List.of(edges));
  print(
    'Kruskal MST edges: ${mstKruskal.map((e) => '(${e.source}-${e.target}:${e.weight})').toList()}',
  );
  print(
    'Prim MST weight: ${primMST(weighted).fold<num>(0, (s, e) => s + e.weight)}',
  );

  final sccs = kosarajuSCC(<int, List<int>>{
    1: [2],
    2: [3],
    3: [1, 4],
    4: [5],
    5: [6],
    6: [4],
  });
  print('Kosaraju SCC count: ${sccs.length}');
  print(
    'Articulation Points: ${articulationPoints(<int, List<int>>{
      1: [2],
      2: [1, 3, 4],
      3: [2],
      4: [2],
    })}',
  );

  // =========================
  // Tree Algorithms
  // =========================
  print('🌳 Binary Tree Algorithms Example\n');

  // Create a sample binary tree
  //       10
  //      /  \
  //     5    15
  //    / \   / \
  //   3   7 12  20
  //  /     \
  // 1       9
  final root = BinaryTreeNode<int>(10);
  root.left = BinaryTreeNode<int>(5);
  root.right = BinaryTreeNode<int>(15);
  root.left!.left = BinaryTreeNode<int>(3);
  root.left!.right = BinaryTreeNode<int>(7);
  root.right!.left = BinaryTreeNode<int>(12);
  root.right!.right = BinaryTreeNode<int>(20);
  root.left!.left!.left = BinaryTreeNode<int>(1);
  root.left!.right!.right = BinaryTreeNode<int>(9);

  print('📊 Tree Traversals:');
  print('Inorder: ${inorderTraversal(root)}');
  print('Preorder: ${preorderTraversal(root)}');
  print('Postorder: ${postorderTraversal(root)}');
  print('Level Order: ${levelOrderTraversal(root)}');
  print('Zigzag: ${zigzagTraversal(root)}');
  print('');

  print('🔍 Tree Properties:');
  print('Depth: ${treeDepth(root)}');
  print('Diameter: ${binaryTreeDiameter(root)}');
  print('Is Balanced: ${isBalancedTree(root)}');
  print('Is Valid BST: ${validateBST(root)}');
  print('');

  print('🔄 Tree Operations:');
  print(
    'Lowest Common Ancestor of 1 and 9: ${lowestCommonAncestor(root, 1, 9)?.value}',
  );
  print(
    'Lowest Common Ancestor of 3 and 7: ${lowestCommonAncestor(root, 3, 7)?.value}',
  );
  print('');

  print('📝 Serialization:');
  final serialized = serializeTree(root);
  print('Serialized: $serialized');
  final deserialized = deserializeTree<int>(serialized);
  print('Deserialized level order: ${levelOrderTraversal(deserialized)}');
  print('');

  print('🔄 Tree Inversion:');
  final inverted = invertTree(root);
  print('Inverted level order: ${levelOrderTraversal(inverted)}');
  print('');

  // Create a valid BST for comparison
  print('🌲 Binary Search Tree Example:');
  final bstRoot = BinaryTreeNode<int>(10);
  bstRoot.left = BinaryTreeNode<int>(5);
  bstRoot.right = BinaryTreeNode<int>(15);
  bstRoot.left!.left = BinaryTreeNode<int>(3);
  bstRoot.left!.right = BinaryTreeNode<int>(7);
  bstRoot.right!.left = BinaryTreeNode<int>(12);
  bstRoot.right!.right = BinaryTreeNode<int>(20);

  print('Is Valid BST: ${validateBST(bstRoot)}');
  print('Inorder traversal (should be sorted): ${inorderTraversal(bstRoot)}');
  print('');

  print('✨ All tree algorithms are working correctly!');

  // =========================
  // Linked List Algorithms
  // =========================
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

  print('✅ All linked list algorithms demonstrated successfully!');
  // =========================
  // Dynamic Programming (DP) Algorithms
  // =========================
  // 🧮 Fibonacci (Memoization)
  print('Fibonacci(10): ${fibonacciMemo(10)}');

  // 🎒 0/1 Knapsack
  print('Knapsack01: ${knapsack01([1, 2, 3], [6, 10, 12], 5)}');

  // 📈 Longest Increasing Subsequence
  print('LIS: ${longestIncreasingSubsequence([10, 9, 2, 5, 3, 7, 101, 18])}');

  // 🔗 Longest Common Subsequence
  print('LCS: ${longestCommonSubsequence("abcde", "ace")}');

  // ✏️ Edit Distance
  print('Edit Distance: ${editDistance("kitten", "sitting")}');

  // 🧮 Matrix Path Sum
  print(
    'Min Path Sum: ${minPathSum([
      [1, 3, 1],
      [1, 5, 1],
      [4, 2, 1],
    ])}',
  );

  // 💰 Coin Change
  print('Coin Change: ${coinChange([1, 2, 5], 11)}');

  // 🔢 Subset Sum
  print('Subset Sum: ${subsetSum([3, 34, 4, 12, 5, 2], 9)}');

  // ⚖️ Partition Equal Subset Sum
  print('Can Partition: ${canPartition([1, 5, 11, 5])}');

  // 🏠 House Robber
  print('House Robber: ${houseRobber([2, 7, 9, 3, 1])}');

  // 🏃 Jump Game
  print('Can Jump: ${canJump([2, 3, 1, 1, 4])}');

  // 🔄 Alternating Subsequences
  print(
    'Longest Alternating Subsequence: ${longestAlternatingSubsequence([1, 7, 4, 9, 2, 5])}',
  );

  // 🪚 Rod Cutting
  print('Rod Cutting: ${rodCutting([1, 5, 8, 9, 10, 17, 17, 20], 8)}');
  //-------------------------
  // Backtracking Algorithms
  //-------------------------
  // 👑 N-Queens
  print('N-Queens (n=4):');
  for (var board in solveNQueens(4)) {
    for (var row in board) {
      print(row);
    }
    print('');
  }

  // 🧩 Sudoku Solver
  var sudoku = [
    ['5', '3', '.', '.', '7', '.', '.', '.', '.'],
    ['6', '.', '.', '1', '9', '5', '.', '.', '.'],
    ['.', '9', '8', '.', '.', '.', '.', '6', '.'],
    ['8', '.', '.', '.', '6', '.', '.', '.', '3'],
    ['4', '.', '.', '8', '.', '3', '.', '.', '1'],
    ['7', '.', '.', '.', '2', '.', '.', '.', '6'],
    ['.', '6', '.', '.', '.', '.', '2', '8', '.'],
    ['.', '.', '.', '4', '1', '9', '.', '.', '5'],
    ['.', '.', '.', '.', '8', '.', '.', '7', '9'],
  ];
  solveSudoku(sudoku);
  print('Sudoku Solved:');
  for (var row in sudoku) {
    print(row);
  }

  // 🔢 Subset Generation
  print('Subsets of [1,2,3]: ${subsets([1, 2, 3])}');

  // 🔄 Permutations
  print('Permutations of [1,2,3]: ${permutations([1, 2, 3])}');

  // 🔍 Word Search
  var board = [
    ['A', 'B', 'C', 'E'],
    ['S', 'F', 'C', 'S'],
    ['A', 'D', 'E', 'E'],
  ];
  print('Word "ABCCED" exists: ${wordSearch(board, "ABCCED")}');

  // 🔢 Combinations
  print('Combinations of 4 choose 2: ${combine(4, 2)}');

  // ➕ Combination Sum
  print(
    'Combination Sum [2,3,6,7] target 7: ${combinationSum([2, 3, 6, 7], 7)}',
  );

  // ☎️ Letter Combinations of Phone Number
  print('Letter Combinations for "23": ${letterCombinations("23")}');

  // 🐀 Rat in a Maze
  var maze = [
    [1, 0, 0, 0],
    [1, 1, 0, 1],
    [0, 1, 0, 0],
    [1, 1, 1, 1],
  ];
  print('Rat in a Maze paths: ${ratInMaze(maze)}');
  //-------------------------
  //matrix
  //-------------------------
  // 🎨 Flood Fill
  var image = [
    [1, 1, 1],
    [1, 1, 0],
    [1, 0, 1],
  ];
  print('Flood Fill: ${floodFill(image, 1, 1, 2)}');

  // 🏝️ Island Count (DFS)
  var grid1 = [
    ['1', '1', '0', '0', '0'],
    ['1', '1', '0', '0', '0'],
    ['0', '0', '1', '0', '0'],
    ['0', '0', '0', '1', '1'],
  ];
  print('Island Count (DFS): ${numIslandsDFS(grid1)}');

  // 🏝️ Island Count (BFS)
  var grid2 = [
    ['1', '1', '0', '0', '0'],
    ['1', '1', '0', '0', '0'],
    ['0', '0', '1', '0', '0'],
    ['0', '0', '0', '1', '1'],
  ];
  print('Island Count (BFS): ${numIslandsBFS(grid2)}');

  // 🚦 Shortest Path in Grid
  var grid3 = [
    [1, 1, 0, 1],
    [1, 1, 1, 1],
    [0, 1, 0, 1],
    [1, 1, 1, 1],
  ];
  print('Shortest Path in Grid: ${shortestPathInGrid(grid3)}');

  // ➕ Path Sum in Matrix
  var matrix = [
    [5, 4, 2],
    [1, 9, 1],
    [1, 1, 1],
  ];
  print('Path Sum 14: ${hasPathSum(matrix, 14)}');

  // 🔄 Matrix Rotation
  var mat = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];
  rotateMatrix(mat);
  print('Matrix Rotation: $mat');

  // 🌀 Spiral Traversal
  var spiral = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];
  print('Spiral Traversal: ${spiralOrder(spiral)}');

  // 🏝️ Surrounded Regions
  var board2 = [
    ['X', 'X', 'X', 'X'],
    ['X', 'O', 'O', 'X'],
    ['X', 'X', 'O', 'X'],
    ['X', 'O', 'X', 'X'],
  ];
  solveSurroundedRegions(board2);
  print('Surrounded Regions: $board2');
}
