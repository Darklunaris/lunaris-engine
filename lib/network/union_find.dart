/// 🔗 Union-Find / Disjoint Set Data Structure
///
/// A highly efficient data structure for managing a collection of disjoint sets
/// with fast union and find operations. Implements path compression and union by rank
/// for optimal performance.
///
/// - **Time Complexity**:
///   - Find: O(α(n)) amortized (inverse Ackermann function)
///   - Union: O(α(n)) amortized
///   - MakeSet: O(1)
/// - **Space Complexity**: O(n) where n is the number of elements
/// - **Optimality**: Near-constant time complexity in practice
/// - **Applications**: Network connectivity, Kruskal's MST, image processing
///
/// The data structure uses path compression and union by rank to achieve
/// near-constant time complexity for all operations.
///
/// Example:
/// ```dart
/// final uf = UnionFind<String>();
/// uf.makeSet('A');
/// uf.makeSet('B');
/// uf.makeSet('C');
///
/// uf.union('A', 'B');
/// print(uf.find('A') == uf.find('B')); // true
/// print(uf.find('A') == uf.find('C')); // false
///
/// uf.union('B', 'C');
/// print(uf.find('A') == uf.find('C')); // true
/// ```
library;

/// Represents a node in the Union-Find data structure
class UnionFindNode<T> {
  T value;
  UnionFindNode<T>? parent;
  int rank;

  UnionFindNode(this.value) : rank = 0;

  @override
  String toString() => 'UnionFindNode($value, rank: $rank)';
}

/// Union-Find / Disjoint Set data structure implementation
///
/// Provides efficient union and find operations for managing disjoint sets.
/// Uses path compression and union by rank for optimal performance.
class UnionFind<T> {
  final Map<T, UnionFindNode<T>> _nodes = {};
  int _setCount = 0;

  /// Creates a new Union-Find data structure
  UnionFind();

  /// Creates a Union-Find from an existing collection of elements
  ///
  /// Each element starts in its own set
  UnionFind.fromElements(Iterable<T> elements) {
    for (final element in elements) {
      makeSet(element);
    }
  }

  /// Creates a new set containing the given element
  ///
  /// If the element already exists, this operation has no effect.
  void makeSet(T element) {
    if (!_nodes.containsKey(element)) {
      _nodes[element] = UnionFindNode<T>(element);
      _setCount++;
    }
  }

  /// Finds the representative (root) of the set containing the given element
  ///
  /// Implements path compression for optimal performance.
  /// Returns null if the element doesn't exist.
  T? find(T element) {
    final node = _nodes[element];
    if (node == null) return null;

    // Path compression: make all nodes on the path point directly to the root
    if (node.parent != null) {
      node.parent = _nodes[_findRoot(node)]!;
    }

    return _findRoot(node);
  }

  /// Finds the root node of the given node
  T _findRoot(UnionFindNode<T> node) {
    if (node.parent == null) {
      return node.value;
    }

    // Recursive path compression
    final root = _findRoot(node.parent!);
    node.parent = _nodes[root]!;
    return root;
  }

  /// Unions the sets containing the two given elements
  ///
  /// Implements union by rank for optimal performance.
  /// If either element doesn't exist, this operation has no effect.
  void union(T element1, T element2) {
    final root1 = find(element1);
    final root2 = find(element2);

    if (root1 == null || root2 == null || root1 == root2) {
      return; // Elements don't exist or are already in the same set
    }

    final node1 = _nodes[root1]!;
    final node2 = _nodes[root2]!;

    // Union by rank: attach smaller tree to larger tree
    if (node1.rank < node2.rank) {
      node1.parent = node2;
    } else if (node1.rank > node2.rank) {
      node2.parent = node1;
    } else {
      // Same rank, attach one to the other and increment rank
      node2.parent = node1;
      node1.rank++;
    }

    _setCount--;
  }

  /// Checks if two elements are in the same set
  bool isConnected(T element1, T element2) {
    final root1 = find(element1);
    final root2 = find(element2);
    return root1 != null && root2 != null && root1 == root2;
  }

  /// Gets the number of disjoint sets
  int get setCount => _setCount;

  /// Gets the total number of elements
  int get elementCount => _nodes.length;

  /// Gets the size of the set containing the given element
  int getSetSize(T element) {
    final root = find(element);
    if (root == null) return 0;

    int size = 0;
    for (final node in _nodes.values) {
      if (find(node.value) == root) {
        size++;
      }
    }
    return size;
  }

  /// Gets all elements in the same set as the given element
  Set<T> getSetElements(T element) {
    final root = find(element);
    if (root == null) return <T>{};

    final elements = <T>{};
    for (final node in _nodes.values) {
      if (find(node.value) == root) {
        elements.add(node.value);
      }
    }
    return elements;
  }

  /// Gets all sets as a list of sets
  List<Set<T>> getAllSets() {
    final sets = <Set<T>>[];
    final processed = <T>{};

    for (final element in _nodes.keys) {
      if (!processed.contains(element)) {
        final setElements = getSetElements(element);
        sets.add(setElements);
        processed.addAll(setElements);
      }
    }

    return sets;
  }

  /// Gets the largest set size
  int get largestSetSize {
    if (_nodes.isEmpty) return 0;

    int maxSize = 0;
    for (final element in _nodes.keys) {
      final size = getSetSize(element);
      if (size > maxSize) maxSize = size;
    }

    return maxSize;
  }

  /// Gets the average set size
  double get averageSetSize {
    if (_setCount == 0) return 0.0;
    return elementCount / _setCount;
  }

  /// Resets the Union-Find to contain only the given elements
  ///
  /// Each element starts in its own set
  void reset(Iterable<T> elements) {
    _nodes.clear();
    _setCount = 0;
    for (final element in elements) {
      makeSet(element);
    }
  }

  /// Removes all elements and sets
  void clear() {
    _nodes.clear();
    _setCount = 0;
  }

  /// Checks if the given element exists in any set
  bool contains(T element) => _nodes.containsKey(element);

  /// Gets all elements in the Union-Find
  Set<T> get elements => _nodes.keys.toSet();

  @override
  String toString() {
    final sets = getAllSets();
    return 'UnionFind(sets: $sets, totalElements: $elementCount, setCount: $_setCount)';
  }
}

/// Enhanced Union-Find with detailed statistics and analysis
class UnionFindDetailed<T> extends UnionFind<T> {
  final Map<T, int> _operationCount = {};
  final List<Map<String, dynamic>> _operationHistory = [];

  /// Creates a new detailed Union-Find data structure
  UnionFindDetailed();

  /// Creates a detailed Union-Find from an existing collection
  UnionFindDetailed.fromElements(super.elements) : super.fromElements();

  @override
  void makeSet(T element) {
    super.makeSet(element);
    _recordOperation('makeSet', element, null);
  }

  @override
  T? find(T element) {
    final result = super.find(element);
    _recordOperation('find', element, result);
    _incrementOperationCount(element);
    return result;
  }

  @override
  void union(T element1, T element2) {
    final beforeSet1 = super.getSetSize(element1);
    final beforeSet2 = super.getSetSize(element2);

    super.union(element1, element2);

    final afterSet1 = super.getSetSize(element1);
    final afterSet2 = super.getSetSize(element2);

    _recordOperation('union', element1, element2, {
      'beforeSet1Size': beforeSet1,
      'beforeSet2Size': beforeSet2,
      'afterSet1Size': afterSet1,
      'afterSet2Size': afterSet2,
    });

    _incrementOperationCount(element1);
    _incrementOperationCount(element2);
  }

  /// Records an operation for analysis
  void _recordOperation(
    String operation,
    T element1,
    dynamic element2, [
    Map<String, dynamic>? metadata,
  ]) {
    _operationHistory.add({
      'operation': operation,
      'element1': element1,
      'element2': element2,
      'timestamp': DateTime.now(),
      'setCount': setCount,
      'elementCount': elementCount,
      ...?metadata,
    });
  }

  /// Increments the operation count for an element
  void _incrementOperationCount(T element) {
    _operationCount[element] = (_operationCount[element] ?? 0) + 1;
  }

  /// Gets the operation count for a specific element
  int getOperationCount(T element) => _operationCount[element] ?? 0;

  /// Gets the total number of operations performed
  int get totalOperations => _operationHistory.length;

  /// Gets the operation history
  List<Map<String, dynamic>> get operationHistory =>
      List.unmodifiable(_operationHistory);

  /// Gets the most frequently accessed elements
  List<T> get mostFrequentElements {
    final sorted =
        _operationCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.map((entry) => entry.key).toList();
  }

  /// Gets the least frequently accessed elements
  List<T> get leastFrequentElements {
    final sorted =
        _operationCount.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));
    return sorted.map((entry) => entry.key).toList();
  }

  /// Gets the average operations per element
  double get averageOperationsPerElement {
    if (elementCount == 0) return 0.0;
    return totalOperations / elementCount;
  }

  /// Gets the operation distribution
  Map<String, int> get operationDistribution {
    final distribution = <String, int>{};
    for (final operation in _operationHistory) {
      final op = operation['operation'] as String;
      distribution[op] = (distribution[op] ?? 0) + 1;
    }
    return distribution;
  }

  /// Gets the set size distribution
  Map<int, int> get setSizeDistribution {
    final distribution = <int, int>{};
    final sets = getAllSets();

    for (final set in sets) {
      final size = set.length;
      distribution[size] = (distribution[size] ?? 0) + 1;
    }

    return distribution;
  }

  /// Gets performance statistics
  Map<String, dynamic> get performanceStats {
    return {
      'totalOperations': totalOperations,
      'setCount': setCount,
      'elementCount': elementCount,
      'largestSetSize': largestSetSize,
      'averageSetSize': averageSetSize,
      'averageOperationsPerElement': averageOperationsPerElement,
      'operationDistribution': operationDistribution,
      'setSizeDistribution': setSizeDistribution,
      'mostFrequentElements': mostFrequentElements.take(5).toList(),
      'leastFrequentElements': leastFrequentElements.take(5).toList(),
    };
  }

  /// Clears the operation history and statistics
  void clearHistory() {
    _operationHistory.clear();
    _operationCount.clear();
  }
}
