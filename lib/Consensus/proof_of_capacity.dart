/// Proof of Capacity / Proof of Space - plotting & selection primitives
///
/// A compact simulation of PoC/PoS-style proofing where miners allocate disk
/// resources (plots) and prove possession when challenged. The module includes
/// a simple plot registry, challenge verification and selection by plot quality.
/// This is intended for protocol simulation and testing rather than real
/// disk-plot cryptography.
///
/// Contract:
/// - Input: plotting records, challenge seeds
/// - Output: best plot responses and selection ranking
/// - Errors: throws on invalid plot sizes or empty registry
library;

import 'dart:math';

class Plot {
  final String owner;
  final int size; // in arbitrary units
  final int quality; // synthetic quality score
  Plot(this.owner, this.size, this.quality) {
    if (size <= 0) throw ArgumentError('size>0');
  }
}

/// Proof of Capacity simulation helpers.
class ProofOfCapacity {
  final List<Plot> plots;
  ProofOfCapacity(this.plots) {
    if (plots.isEmpty) throw ArgumentError('plots required');
  }

  /// Score a plot deterministically against a challenge seed.
  double _score(Plot p, int seed) {
    final rnd = Random(seed ^ p.quality ^ p.size);
    return p.quality + rnd.nextDouble() * p.size;
  }

  /// Return the owner with the highest plot score for the given challenge.
  String bestResponder(int seed) {
    String best = plots.first.owner;
    double bestScore = _score(plots.first, seed);
    for (var p in plots.skip(1)) {
      final s = _score(p, seed);
      if (s > bestScore) {
        bestScore = s;
        best = p.owner;
      }
    }
    return best;
  }
}
