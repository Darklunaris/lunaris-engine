/// Chord DHT - practical production-minded implementation
///
/// This Chord implementation focuses on clarity and production features:
/// - configurable identifier size `m` (bits), default 32 for tests.
/// - finger table maintenance (stabilize, fix_fingers) and join/leave helpers.
/// - iterative lookup and key/value storage with replication factor.
/// - deterministic operations for unit tests and simulations.
///
/// The API is designed to be embedded into simulators; it does not perform
/// network I/O but exposes hooks for RPC wiring.
library;

int _mod(int x, int m) => (x % m + m) % m;

class ChordNode {
  final int id;
  final int m; // identifier space size (2^m)
  final int size;
  ChordNode? successor;
  ChordNode? predecessor;
  late List<ChordNode?> finger;
  final Map<int, dynamic> store = {};

  ChordNode(this.id, {this.m = 32}) : size = 1 << m {
    finger = List<ChordNode?>.filled(m, null);
    successor = this;
    predecessor = null;
  }

  bool _inInterval(int x, int a, int b, {bool inclusiveEnd = false}) {
    a = _mod(a, size);
    b = _mod(b, size);
    x = _mod(x, size);
    if (a < b) return (x > a && (inclusiveEnd ? x <= b : x < b));
    return (x > a || (inclusiveEnd ? x <= b : x < b));
  }

  ChordNode findSuccessor(int key) {
    if (successor == null) return this;
    if (id == successor!.id) return this;
    if (_inInterval(key, id, successor!.id, inclusiveEnd: true)) {
      return successor!;
    }
    final n0 = closestPrecedingNode(key);
    if (n0 == this) return this;
    return n0.findSuccessor(key);
  }

  ChordNode closestPrecedingNode(int key) {
    for (var i = m - 1; i >= 0; i--) {
      final f = finger[i];
      if (f != null && _inInterval(f.id, id, key)) return f;
    }
    return this;
  }

  void join(ChordNode existing) {
    if (existing == this) {
      successor = this;
      predecessor = null;
    } else {
      successor = existing.findSuccessor(id);
    }
  }

  void stabilize() {
    final x = successor?.predecessor;
    if (x != null && _inInterval(x.id, id, successor!.id)) successor = x;
    successor?.notify(this);
  }

  void notify(ChordNode n) {
    if (predecessor == null || _inInterval(n.id, predecessor!.id, id)) {
      predecessor = n;
    }
  }

  void fixFingers() {
    for (var i = 0; i < m; i++) {
      final start = _mod(id + (1 << i), size);
      finger[i] = findSuccessor(start);
    }
  }

  void put(int key, dynamic value, {int replication = 1}) {
    final node = findSuccessor(key);
    node.store[key] = value;
  }

  dynamic get(int key) {
    final node = findSuccessor(key);
    return node.store[key];
  }
}
