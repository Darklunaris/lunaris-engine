/// 🌐 Network Algorithms Library
///
/// A comprehensive collection of production-grade network algorithms for
/// solving complex graph and network problems efficiently.
///
/// This library provides implementations of:
/// - **Path Finding**: A* algorithm with heuristics
/// - **Maximum Flow**: Ford-Fulkerson, Edmonds-Karp, and Dinic's algorithms
/// - **Connectivity Analysis**: Tarjan's algorithm for bridges and articulation points
/// - **Data Structures**: Union-Find/Disjoint Set with path compression
///
/// All algorithms are implemented with:
/// - Full generic type support (T-variants)
/// - Comprehensive error handling
/// - Performance optimizations
/// - Detailed documentation and examples
/// - Production-ready code quality
library;

// Path Finding Algorithms
export 'a_star.dart';

// Maximum Flow Algorithms
export 'ford_fulkerson.dart' hide min;
export 'edmonds_karp.dart' hide min;
export 'dinics_algorithm.dart' hide min;

// Connectivity Analysis
export 'tarjans_algorithm.dart' hide min;

// Data Structures
export 'union_find.dart' hide UnionFind;
