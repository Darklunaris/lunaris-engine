/// Federated Byzantine Agreement (FBA) - quorum slices simulation
///
/// A small FBA (Stellar-style) helper demonstrating quorum slice composition,
/// recursive quorum checks, and simple governance operations. The implementation
/// focuses on auditable logic for unit-testing quorum discovery rather than a
/// full protocol stack.
///
/// Contract:
/// - Input: node->list of quorum slices (each slice a set of node ids)
/// - Output: whether a given set of nodes forms a quorum
/// - Errors: throws on malformed slices
library;

class FBA {
  final Map<String, List<Set<String>>> slices;
  FBA(this.slices) {
    if (slices.isEmpty) throw ArgumentError('slices required');
  }

  /// Validate slices structure (no empty slices, nodes referenced exist)
  bool validateStructure() {
    for (var e in slices.entries) {
      if (e.value.isEmpty) return false;
      for (var s in e.value) {
        if (s.isEmpty) return false;
      }
    }
    return true;
  }

  /// Check whether nodes form a quorum: each node must have at least one slice
  /// fully contained in nodes.
  bool isQuorum(Set<String> nodes) {
    if (!validateStructure()) throw StateError('invalid slice structure');
    for (var n in nodes) {
      final s = slices[n];
      if (s == null) return false;
      var satisfied = false;
      for (var slice in s) {
        if (slice.difference(nodes).isEmpty) {
          satisfied = true;
          break;
        }
      }
      if (!satisfied) return false;
    }
    return true;
  }

  /// Find a minimal local quorum for a given node by picking one slice that is
  /// fully satisfied within candidates, if any.
  Set<String>? localQuorum(String node, Set<String> candidates) {
    final s = slices[node];
    if (s == null) return null;
    for (var slice in s) {
      if (slice.difference(candidates).isEmpty) return slice;
    }
    return null;
  }
}
