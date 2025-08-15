import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:lunaris_engine/lunaris_engine.dart';
import 'dart:io';
import 'dart:developer' as developer;

void main() {
  print('--- lunaris_engine Benchmark Suite ---');
  print(
    'Each result is average time per operation (us/op) and memory usage (KB)',
  );
  print('');
  print('Dart version: ${Platform.version}');
  print(
    'Platform: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
  );
  print('---\n');

  // List Algorithms
  runWithMemory(MaxSumSubarrayIntBenchmark());
  runWithMemory(MaxSumSubarrayDoubleBenchmark());
  runWithMemory(BubbleSortBenchmark());
  runWithMemory(QuickSortBenchmark());
  runWithMemory(MergeSortBenchmark());

  // Set Algorithms
  runWithMemory(HasDuplicatesBenchmark());

  // Map Algorithms
  runWithMemory(FrequencyCountBenchmark());

  // String Algorithms
  runWithMemory(ReverseStringBenchmark());

  // Graph Algorithms
  runWithMemory(DijkstraBenchmark());
  runWithMemory(BFSBenchmark());
  runWithMemory(DFSBenchmark());

  // Advanced Graph Algorithms
  runWithMemory(EdmondsKarpBenchmark());
  runWithMemory(DinicsAlgorithmBenchmark());
  runWithMemory(JohnsonsAlgorithmBenchmark());
  runWithMemory(StoerWagnerMinCutBenchmark());

  // Compression algorithms
  runWithMemory(RleBenchmark());
  runWithMemory(HuffmanBenchmark());
  runWithMemory(LzwBenchmark());
  runWithMemory(BwtBenchmark());
  runWithMemory(ArithmeticBenchmark());

  // Network optimization
  runWithMemory(DinicMaxFlowBenchmark());
  runWithMemory(MinCostFlowBenchmark());
  runWithMemory(HungarianBenchmark());

  // Wireless / P2P
  runWithMemory(ChordLookupBenchmark());
  runWithMemory(AodvSendBenchmark());
  // ML, routing, consensus
  runWithMemory(MlMatrixMulBenchmark());
  runWithMemory(RoutingDistanceVectorBenchmark());
  runWithMemory(ConsensusProofOfWorkBenchmark());
}

// ML / simple matrix multiply benchmark
class MlMatrixMulBenchmark extends BenchmarkBase {
  MlMatrixMulBenchmark() : super('ml_matrix_mul');
  final int n = 64;
  List<List<double>> _make() =>
      List.generate(n, (_) => List.generate(n, (_) => 1.0));
  @override
  void run() {
    final a = _make();
    final b = _make();
    final c = List.generate(n, (_) => List<double>.filled(n, 0.0));
    for (var i = 0; i < n; i++) {
      for (var k = 0; k < n; k++) {
        final aik = a[i][k];
        for (var j = 0; j < n; j++) {
          c[i][j] += aik * b[k][j];
        }
      }
    }
  }
}

// Routing algorithms - small distance-vector simulation step
class RoutingDistanceVectorBenchmark extends BenchmarkBase {
  final int n = 20;
  final List<Map<int, int>> graph = [];
  RoutingDistanceVectorBenchmark() : super('routing_distance_vector') {
    for (var i = 0; i < n; i++) {
      graph.add({});
    }
    for (var i = 0; i < n - 1; i++) {
      graph[i][i + 1] = 1;
      graph[i + 1][i] = 1;
    }
  }
  @override
  void run() {
    final dist = List.generate(n, (_) => List<int>.filled(n, 1 << 20));
    for (var i = 0; i < n; i++) {
      dist[i][i] = 0;
      for (var e in graph[i].entries) {
        dist[i][e.key] = e.value;
      }
    }
    // one Bellman-Ford-like iteration for all nodes
    for (var u = 0; u < n; u++) {
      for (var v = 0; v < n; v++) {
        for (var w = 0; w < n; w++) {
          if (dist[u][w] > dist[u][v] + dist[v][w]) {
            dist[u][w] = dist[u][v] + dist[v][w];
          }
        }
      }
    }
  }
}

// Consensus - simple proof-of-work hash attempt loop
class ConsensusProofOfWorkBenchmark extends BenchmarkBase {
  ConsensusProofOfWorkBenchmark() : super('consensus_pow');
  final target = 1 << 20;
  @override
  void run() {
    var nonce = 0;
    var v = 0;
    while (v < target) {
      v = (nonce * 1103515245 + 12345) & 0x7fffffff;
      nonce++;
    }
  }
}

void runWithMemory(BenchmarkBase benchmark) {
  // Warm up
  benchmark.warmup();
  // Request GC and take memory before
  try {
    developer.postEvent('gc', {});
  } catch (_) {}
  final memBefore = ProcessInfo.currentRss;
  // Run benchmark
  final score = benchmark.measure();
  // Request GC and take memory after
  try {
    developer.postEvent('gc', {});
  } catch (_) {}
  final memAfter = ProcessInfo.currentRss;
  final memDelta = memAfter - memBefore;
  final memUsageKb = ((memDelta > 0 ? memDelta : 0) / 1024).toStringAsFixed(2);
  print(
    '${benchmark.runtimeType.toString().padRight(30)} | ${benchmark.name.padRight(30)} | ${score.toStringAsFixed(2).padLeft(10)} us/op | ${memUsageKb.padLeft(8)} KB',
  );
}

// List Algorithms
class MaxSumSubarrayIntBenchmark extends BenchmarkBase {
  MaxSumSubarrayIntBenchmark() : super('maxSumSubarrayOfSizeK<int>');
  final list = List<int>.generate(1000, (i) => i % 100);
  @override
  void run() {
    maxSumSubarrayOfSizeK(list, 50);
  }
}

class MaxSumSubarrayDoubleBenchmark extends BenchmarkBase {
  MaxSumSubarrayDoubleBenchmark() : super('maxSumSubarrayOfSizeK<double>');
  final list = List<double>.generate(1000, (i) => (i % 100).toDouble());
  @override
  void run() {
    maxSumSubarrayOfSizeK(list, 50);
  }
}

class BubbleSortBenchmark extends BenchmarkBase {
  BubbleSortBenchmark() : super('bubbleSort');
  final list = List<int>.generate(500, (i) => 500 - i);
  @override
  void run() {
    final copy = List<int>.from(list);
    bubbleSort(copy);
  }
}

class QuickSortBenchmark extends BenchmarkBase {
  QuickSortBenchmark() : super('quickSort');
  final list = List<int>.generate(500, (i) => 500 - i);
  @override
  void run() {
    final copy = List<int>.from(list);
    quickSort(copy, 0, copy.length - 1);
  }
}

class MergeSortBenchmark extends BenchmarkBase {
  MergeSortBenchmark() : super('mergeSort');
  final list = List<int>.generate(500, (i) => 500 - i);
  @override
  void run() {
    mergeSort(list);
  }
}

// Set Algorithms
class HasDuplicatesBenchmark extends BenchmarkBase {
  HasDuplicatesBenchmark() : super('hasDuplicates');
  final list = List<int>.generate(1000, (i) => i % 500);
  @override
  void run() {
    hasDuplicates(list);
  }
}

// Map Algorithms
class FrequencyCountBenchmark extends BenchmarkBase {
  FrequencyCountBenchmark() : super('frequencyCount');
  final list = List<String>.generate(1000, (i) => 'item${i % 10}');
  @override
  void run() {
    frequencyCount(list);
  }
}

// String Algorithms
class ReverseStringBenchmark extends BenchmarkBase {
  ReverseStringBenchmark() : super('reverseString');
  final str = 'a' * 1000;
  @override
  void run() {
    reverseString(str);
  }
}

// Graph Algorithms
class DijkstraBenchmark extends BenchmarkBase {
  DijkstraBenchmark() : super('dijkstra');
  final Map<String, List<WeightedEdge<String>>> graph = {
    'A': [WeightedEdge('A', 'B', 1), WeightedEdge('A', 'C', 4)],
    'B': [WeightedEdge('B', 'C', 2), WeightedEdge('B', 'D', 5)],
    'C': [WeightedEdge('C', 'D', 1)],
    'D': [],
  };
  @override
  void run() {
    dijkstra(graph, 'A');
  }
}

class BFSBenchmark extends BenchmarkBase {
  BFSBenchmark() : super('bfs');
  final Map<String, List<String>> graph = {
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': ['F'],
    'D': [],
    'E': ['F'],
    'F': [],
  };
  @override
  void run() {
    bfs(graph, 'A');
  }
}

class DFSBenchmark extends BenchmarkBase {
  DFSBenchmark() : super('dfs');
  final Map<String, List<String>> graph = {
    'A': ['B', 'C'],
    'B': ['D', 'E'],
    'C': ['F'],
    'D': [],
    'E': ['F'],
    'F': [],
  };
  @override
  void run() {
    dfs(graph, 'A');
  }
}

// Advanced Graph Algorithms
class EdmondsKarpBenchmark extends BenchmarkBase {
  EdmondsKarpBenchmark() : super('edmondsKarp');
  final Map<String, Map<String, num>> graph = {
    'S': {'A': 10, 'C': 10},
    'A': {'B': 4, 'C': 2, 'D': 8},
    'B': {'D': 10},
    'C': {'D': 9},
    'D': {},
  };
  @override
  void run() {
    edmondsKarp(graph, 'S', 'D');
  }
}

class DinicsAlgorithmBenchmark extends BenchmarkBase {
  DinicsAlgorithmBenchmark() : super('dinicsAlgorithm');
  final Map<String, Map<String, num>> graph = {
    'S': {'A': 10, 'C': 10},
    'A': {'B': 4, 'C': 2, 'D': 8},
    'B': {'D': 10},
    'C': {'D': 9},
    'D': {},
  };
  @override
  void run() {
    dinicsAlgorithm(graph, 'S', 'D');
  }
}

class JohnsonsAlgorithmBenchmark extends BenchmarkBase {
  JohnsonsAlgorithmBenchmark() : super('johnsonsAlgorithm');
  final Map<String, Map<String, num>> graph = {
    'A': {'B': 2, 'C': 4},
    'B': {'C': 1, 'D': 7},
    'C': {'D': 3},
    'D': {'A': 5},
  };
  @override
  void run() {
    johnsonsAlgorithm(graph);
  }
}

class StoerWagnerMinCutBenchmark extends BenchmarkBase {
  StoerWagnerMinCutBenchmark() : super('stoerWagnerMinCut');
  final Map<int, Map<int, num>> graph = {
    0: {1: 3, 2: 1},
    1: {0: 3, 2: 3},
    2: {0: 1, 1: 3},
  };
  @override
  void run() {
    stoerWagnerMinCut(graph);
  }
}

// Compression Benchmarks
class RleBenchmark extends BenchmarkBase {
  RleBenchmark() : super('rle_encode_decode');
  final data = List<int>.generate(4096, (i) => i % 256);
  @override
  void run() {
    final rle = RLE();
    final e = rle.encode(data);
    rle.decode(e);
  }
}

class HuffmanBenchmark extends BenchmarkBase {
  HuffmanBenchmark() : super('huffman_encode_decode');
  final data = List<int>.generate(4096, (i) => i % 256);
  @override
  void run() {
    final h = Huffman();
    h.build(data);
    final e = h.encodeBytes(data);
    h.decodeBytes(e);
  }
}

class LzwBenchmark extends BenchmarkBase {
  LzwBenchmark() : super('lzw_encode_decode');
  final data = List<int>.generate(4096, (i) => i % 256);
  @override
  void run() {
    final l = LZW();
    final e = l.encode(data);
    l.decode(e);
  }
}

class BwtBenchmark extends BenchmarkBase {
  BwtBenchmark() : super('bwt_transform_inverse');
  final data = List<int>.generate(2048, (i) => i % 256);
  @override
  void run() {
    final t = bwtTransform(data);
    bwtInverse(t);
  }
}

class ArithmeticBenchmark extends BenchmarkBase {
  ArithmeticBenchmark() : super('arithmetic_encode_decode');
  final data = List<int>.generate(1024, (i) => i % 64);
  @override
  void run() {
    final freq = <int, int>{};
    for (var b in data) {
      freq[b] = (freq[b] ?? 0) + 1;
    }
    final alphabet = freq.keys.toList()..sort();
    final freqs = alphabet.map((a) => freq[a]!).toList();
    final ac = Arithmetic();
    final e = ac.encode(data);
    ac.decode(e, alphabet, freqs, data.length);
  }
}

// Network optimization benchmarks
class DinicMaxFlowBenchmark extends BenchmarkBase {
  DinicMaxFlowBenchmark() : super('dinic_max_flow');
  final Dinic g = Dinic(6);
  void _build() {
    g.addEdge(0, 1, 10);
    g.addEdge(0, 2, 10);
    g.addEdge(1, 3, 4);
    g.addEdge(1, 2, 2);
    g.addEdge(2, 4, 9);
    g.addEdge(3, 5, 10);
    g.addEdge(4, 5, 10);
  }

  @override
  void run() {
    _build();
    g.maxFlow(0, 5);
  }
}

class MinCostFlowBenchmark extends BenchmarkBase {
  MinCostFlowBenchmark() : super('min_cost_flow');
  final mcf = MinCostFlow(4);
  void _build() {
    mcf.addEdge(0, 1, 10, 2);
    mcf.addEdge(0, 2, 5, 4);
    mcf.addEdge(1, 2, 15, 1);
    mcf.addEdge(1, 3, 10, 3);
    mcf.addEdge(2, 3, 10, 2);
  }

  @override
  void run() {
    _build();
    mcf.minCostMaxFlow(0, 3, 10);
  }
}

class HungarianBenchmark extends BenchmarkBase {
  HungarianBenchmark() : super('hungarian');
  final List<List<int>> cost = List.generate(
    8,
    (i) => List.generate(8, (j) => (i + j) % 10 + i),
  );
  @override
  void run() {
    hungarian(cost);
  }
}

// Wireless/P2P benchmarks
class ChordLookupBenchmark extends BenchmarkBase {
  ChordLookupBenchmark() : super('chord_lookup');
  final network = List<ChordNode>.generate(16, (i) => ChordNode(i, m: 4));
  void _bootstrap() {
    for (var i = 1; i < network.length; i++) {
      network[i].join(network[0]);
    }
    for (var n in network) {
      n.fixFingers();
    }
  }

  @override
  void run() {
    _bootstrap();
    network[5].findSuccessor(7);
  }
}

class AodvSendBenchmark extends BenchmarkBase {
  AodvSendBenchmark() : super('aodv_send');
  final nodes = List<AodvNode>.generate(8, (i) => AodvNode(i));
  void _wire() {
    for (var i = 0; i < nodes.length; i++) {
      for (var j = 0; j < nodes.length; j++) {
        if ((i - j).abs() == 1) nodes[i].addNeighbor(j);
      }
      nodes[i].sendHook = (from, to, msg) => nodes[to].receive(from, msg);
    }
  }

  @override
  void run() {
    _wire();
    nodes[0].send(7, 'ping');
    for (var n in nodes) {
      n.tick();
    }
  }
}
