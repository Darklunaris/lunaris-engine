# 🌳 lunaris engine Library - Complete Structure Tree

## 📚 Library Overview
```
lunaris_engine/
├── 📖 Documentation & Configuration
│   ├── README.md
│   ├── CHANGELOG.md
│   ├── LICENSE
│   ├── pubspec.yaml
│   └── analysis_options.yaml
├── 🎯 Core Library (lib/)
│   ├── lunaris_engine.dart (Main export file)
│   └── src/
│       └── lunaris_engine_base.dart
├── 🔧 Algorithms by Category
│   ├── 🌲 Tree Algorithms (NEW)
│   ├── 🔗 Linked List Algorithms (NEW)
│   ├── 📊 List Algorithms
│   ├── 🗺️ Map Algorithms
│   ├── 🔍 Set Algorithms
│   ├── 📝 String Algorithms
│   └── 🕸️ Graph Algorithms
├── 🧪 Test Suite (test/)
├── 📚 Examples (example/)
└── 🎨 Assets (logo/)
```

## 🌲 Tree Algorithms (NEW)
```
Tree Algorithms/
├── 🌳 Binary Tree Node
│   └── BinaryTreeNode<T> (Generic tree node with left, right, value)
├── 🔄 Tree Traversals
│   ├── inorderTraversal<T> (Left → Root → Right)
│   ├── preorderTraversal<T> (Root → Left → Right)
│   └── postorderTraversal<T> (Left → Right → Root)
├── 📊 Level Order Traversal
│   └── levelOrderTraversal<T> (BFS - Breadth First Search)
├── 📏 Tree Depth
│   └── treeDepth<T> (Height calculation)
├── 🔄 Tree Inversion
│   └── invertTree<T> (Mirror tree)
├── 🔗 Lowest Common Ancestor
│   └── lowestCommonAncestor<T> (LCA algorithm)
├── ✅ BST Validation
│   └── validateBST<T extends Comparable> (Binary Search Tree validation)
├── 📏 Tree Diameter
│   └── treeDiameter<T> (Longest path between any two nodes)
├── ⚖️ Balanced Tree Check
│   └── isBalanced<T> (Height-balanced tree check)
├── 💾 Tree Serialization
│   ├── serializeTree<T> (Tree to string)
│   └── deserializeTree<T> (String to tree)
└── 🐍 Zigzag Traversal
    └── zigzagTraversal<T> (Alternating level order)
```

## 🔗 Linked List Algorithms (NEW)
```
Linked List Algorithms/
├── 🔗 Linked List Node
│   └── LinkedListNode<T> (Generic singly linked list node)
├── 🔄 Doubly Linked List Node
│   └── DoublyLinkedListNode<T> (Generic doubly linked list node)
├── 📍 Insert/Delete Operations
│   ├── insertAtPosition<T> (Insert at specific position)
│   ├── deleteAtPosition<T> (Delete at specific position)
│   ├── insertAfterValue<T> (Insert after specific value)
│   └── deleteByValue<T> (Delete by value)
├── 🔄 Reverse Operations
│   ├── reverseLinkedList<T> (Iterative reverse)
│   ├── reverseLinkedListRecursive<T> (Recursive reverse)
│   ├── reverseDoublyLinkedList<T> (Doubly linked list reverse)
│   ├── reverseInGroups<T> (Reverse in groups of K)
│   └── reverseBetween<T> (Reverse between positions)
├── 🔍 Cycle Detection
│   ├── detectCycle<T> (Floyd's Tortoise and Hare)
│   ├── findCycleStart<T> (Find cycle start node)
│   ├── getCycleLength<T> (Calculate cycle length)
│   ├── detectCycleWithHashSet<T> (Hash set approach)
│   └── removeCycle<T> (Remove cycle from list)
├── 🔗 Merge Operations
│   ├── mergeSortedLists<T extends Comparable> (Merge two sorted lists)
│   ├── mergeSortedListsRecursive<T extends Comparable> (Recursive merge)
│   ├── mergeKSortedLists<T extends Comparable> (Merge K sorted lists)
│   ├── mergeSortedListsInPlace<T extends Comparable> (In-place merge)
│   └── mergeSortedListsWithComparator<T> (Merge with custom comparator)
├── 🗑️ Remove Operations
│   ├── removeNthFromEnd<T> (Two-pointer approach)
│   ├── removeNthFromEndSinglePass<T> (Single pass)
│   ├── removeNthFromEndRecursive<T> (Recursive approach)
│   └── removeNthFromEndWithReturn<T> (With return value)
├── ✅ Palindrome Check
│   ├── isPalindrome<T> (Two-pointer approach)
│   ├── isPalindromeWithStack<T> (Stack approach)
│   ├── isPalindromeRecursive<T> (Recursive approach)
│   └── isPalindromeWithArray<T> (Array approach)
└── 🔗 Intersection Operations
    ├── getIntersectionNode<T> (Length difference approach)
    ├── getIntersectionNodeWithHashSet<T> (Hash set approach)
    ├── getIntersectionNodeTwoPointer<T> (Two-pointer approach)
    ├── getIntersectionNodeOptimized<T> (Optimized approach)
    └── getIntersectionNodeWithInfo<T> (With additional info)
```

## 📊 List Algorithms
```
List Algorithms/
├── 🔍 Search Algorithms
│   ├── linearSearch<T> (Linear search)
│   ├── binarySearch<T extends Comparable> (Binary search)
│   └── findDuplicates<T> (Find duplicate elements)
├── 📊 Sorting Algorithms
│   ├── bubbleSort<T extends Comparable> (Bubble sort)
│   ├── selectionSort<T extends Comparable> (Selection sort)
│   ├── insertionSort<T extends Comparable> (Insertion sort)
│   ├── mergeSort<T extends Comparable> (Merge sort)
│   ├── quickSort<T extends Comparable> (Quick sort)
│   └── countingSort(List<int>) (Counting sort)
├── 🔄 Array Operations
│   ├── reverseList<T> (Reverse array)
│   ├── rotateArrayRight<T> (Rotate array right)
│   ├── removeDuplicates<T> (Remove duplicates)
│   └── findMaxMin<T extends Comparable> (Find max and min)
├── 📈 Subarray Operations
│   ├── averageSubarray<T extends num> (Average of subarrays)
│   ├── kadanesAlgorithm<T extends num> (Maximum subarray sum)
│   ├── maxSumSubarrayOfSizeK<T extends num> (Max sum of size K)
│   ├── minSum<T extends num> (Minimum sum subarray of size K)
│   └── prefixSum<T extends num> (Prefix sum array)
└── 🔍 Special Operations
    └── twoSumSorted<T extends Comparable> (Two sum in sorted array)
```

## 🗺️ Map Algorithms
```
Map Algorithms/
├── 🔍 Search & Check Operations
│   ├── twoSum<T> (Find two numbers that sum to target)
│   ├── anagramChecker<T> (Check if two maps are anagrams)
│   ├── firstNonRepeatedElement<T> (Find first non-repeated element)
│   └── mostFrequentElement<T> (Find most frequent element)
├── 📊 Frequency Operations
│   ├── frequencyCount<T> (Count frequency of elements)
│   ├── topKFrequent<T> (Find top K frequent elements)
│   └── isFrequencyUnique<T> (Check if frequencies are unique)
├── 🔄 Grouping & Organization
│   ├── groupByKey<T, K> (Group elements by key)
│   └── lengthOfLongestSubstring<T> (Longest substring without repeating)
└── 💾 Cache Operations
    └── LRUCache<K, V> (Least Recently Used cache)
```

## 🔍 Set Algorithms
```
Set Algorithms/
├── 🔍 Check Operations
│   ├── hasDuplicates<T> (Check for duplicates)
│   ├── hasTwoSum<T extends num> (Check if two sum exists)
│   └── hasUniqueWindow<T> (Check for unique window)
├── 🔄 Set Operations
│   ├── findIntersection<T> (Find intersection of sets)
│   ├── setDifference<T> (Find difference between sets)
│   └── isFrequencyUnique<T> (Check if frequencies are unique)
└── 🔗 Disjoint Set
    └── DisjointSet<T> (Union-Find data structure)
```

## 📝 String Algorithms
```
String Algorithms/
├── 🔍 Search Algorithms
│   ├── bruteForceSearch(String, String) (Brute force string search)
│   ├── kmpSearch(String, String) (Knuth-Morris-Pratt algorithm)
│   └── rabinKarpSearch(String, String) (Rabin-Karp algorithm)
├── 🔄 String Operations
│   ├── reverseString(String) (Reverse string)
│   ├── countVowelsConsonants(String) (Count vowels and consonants)
│   └── stringCompression(String) (Compress string)
├── 🔍 Check Operations
│   ├── palindromeChecker(String) (Check if palindrome)
│   └── anagramChecker<T> (Check if anagrams)
├── 📏 String Analysis
│   ├── longestCommonPrefix(List<String>) (Longest common prefix)
│   ├── longestPalindromicSubstring(String) (Longest palindromic substring)
│   └── editDistance(String, String) (Edit distance calculation)
```

## 🕸️ Graph Algorithms
```
Graph Algorithms/
├── 🔍 Traversal Algorithms
│   ├── bfs<T> (Breadth First Search)
│   ├── dfs<T> (Depth First Search)
│   └── topologicalSort<T> (Topological sorting)
├── 🛣️ Shortest Path Algorithms
│   ├── dijkstra<T> (Dijkstra's algorithm)
│   ├── bellmanFord<T> (Bellman-Ford algorithm)
│   ├── floydWarshall<T> (Floyd-Warshall algorithm)
│   └── shortestPath<T> (Generic shortest path)
├── 🌳 Tree & Forest Algorithms
│   ├── mstKruskal<T> (Kruskal's MST algorithm)
│   ├── mstPrim<T> (Prim's MST algorithm)
│   └── unionFind<T> (Union-Find data structure)
├── 🔍 Graph Analysis
│   ├── connectedComponents<T> (Find connected components)
│   ├── cycleDetection<T> (Detect cycles in graph)
│   ├── articulationPoints<T> (Find articulation points)
│   ├── kosarajuSCC<T> (Find strongly connected components)
│   └── bipartiteGraph<T> (Check if graph is bipartite)
└── 🔗 Graph Components
    └── WeightedEdge<T> (Weighted edge representation)
```

## 🧪 Test Structure
```
Test Suite/
├── 🌲 Tree Algorithm Tests (NEW)
│   ├── binary_tree_node_test.dart
│   ├── tree_traversals_test.dart
│   ├── level_order_traversal_test.dart
│   ├── tree_depth_test.dart
│   ├── invert_tree_test.dart
│   ├── lowest_common_ancestor_test.dart
│   ├── validate_bst_test.dart
│   ├── tree_diameter_test.dart
│   ├── balanced_tree_check_test.dart
│   ├── tree_serialization_test.dart
│   └── zigzag_traversal_test.dart
├── 🔗 Linked List Algorithm Tests (NEW)
│   ├── linked_list_node_test.dart
│   ├── doubly_linked_list_node_test.dart
│   ├── insert_delete_at_position_test.dart
│   ├── reverse_linked_list_test.dart
│   ├── detect_cycle_test.dart
│   ├── merge_sorted_lists_test.dart
│   ├── remove_nth_from_end_test.dart
│   ├── palindrome_linked_list_test.dart
│   └── intersection_of_lists_test.dart
├── 📊 List Algorithm Tests
│   ├── binary_search_test.dart
│   ├── bubble_sort_test.dart
│   ├── merge_sort_test.dart
│   ├── quick_sort_test.dart
│   ├── kadanes_algorithm_test.dart
│   └── [other list algorithm tests...]
├── 🗺️ Map Algorithm Tests
│   ├── two_sum_test.dart
│   ├── anagram_checker_test.dart
│   ├── frequency_count_test.dart
│   └── [other map algorithm tests...]
├── 🔍 Set Algorithm Tests
│   ├── disjoint_set_test.dart
│   ├── find_intersection_test.dart
│   └── [other set algorithm tests...]
├── 📝 String Algorithm Tests
│   ├── palindrome_checker_test.dart
│   ├── kmp_search_test.dart
│   ├── edit_distance_test.dart
│   └── [other string algorithm tests...]
├── 🕸️ Graph Algorithm Tests
│   ├── bfs_test.dart
│   ├── dfs_test.dart
│   ├── dijkstra_test.dart
│   ├── mst_test.dart
│   └── [other graph algorithm tests...]
└── 📚 Main Library Test
    └── lunaris_engine_test.dart
```

## 📚 Examples Structure
```
Examples/
├── 📚 Main Example
│   └── lunaris_engine_example.dart (Comprehensive library tour)
├── 🌲 Tree Algorithms Example (NEW)
│   └── tree_algorithms_example.dart (All tree algorithm demonstrations)
└── 🔗 Linked List Algorithms Example (NEW)
    └── linked_list_algorithms_example.dart (All linked list algorithm demonstrations)
```

## 🔧 Technical Features

### 🎯 Generic Type Support
- **All algorithms** support generic type `T`
- **Comparable algorithms** use `T extends Comparable<T>`
- **Type-safe operations** throughout the library

### 📚 Documentation Standards
- **Dartdoc comments** for all public functions
- **Time complexity** analysis (Big O notation)
- **Space complexity** analysis
- **Usage examples** in documentation
- **Emoji indicators** for visual organization

### 🧪 Testing Coverage
- **Unit tests** for all algorithms
- **Edge cases** covered (empty inputs, single elements, etc.)
- **Generic type testing** with different data types
- **Comprehensive scenarios** for complex algorithms

### 🚀 Performance Characteristics
- **Optimized implementations** suitable for production use
- **Efficient algorithms** following best practices
- **Memory-conscious** implementations
- **Scalable solutions** for large datasets

### 🔌 Integration Features
- **Single import** access to all algorithms
- **Consistent API** design across all categories
- **Conflict resolution** for naming overlaps
- **Modular architecture** for easy maintenance

## 🌟 Library Highlights

### ✨ **NEWEST ADDITIONS**
- **Tree Algorithms**: Complete binary tree manipulation suite
- **Linked List Algorithms**: Comprehensive linked list operations
- **Advanced Data Structures**: Generic, production-ready implementations

### 🏆 **Production Quality**
- **Company-ready code** with enterprise-level standards
- **Comprehensive testing** with 100% algorithm coverage
- **Professional documentation** following industry best practices
- **Performance optimized** for real-world applications

### 🔄 **Continuous Evolution**
- **Regular updates** with new algorithm categories
- **Backward compatibility** maintained across versions
- **Community-driven** development approach
- **Open source** with MIT license

---

*This tree represents the complete structure of the lunaris engine Library as of the latest update. The library continues to grow with new algorithm categories and implementations.* 🌱
