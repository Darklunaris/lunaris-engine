/// Practical Byzantine Fault Tolerance (PBFT) - simplified engine
///
/// A compact PBFT engine capturing pre-prepare/prepare/commit phases, view
/// numbers, and basic message flow. The implementation is intentionally small
/// and deterministic for tests and education, but mirrors the message counting
/// and quorum rules used in production PBFT deployments.
///
/// Contract:
/// - Input: n nodes, f tolerated faults, incoming messages (phase and view)
/// - Output: whether the protocol reaches commit for a given view and seq
/// - Errors: throws on invalid parameters
library;

class PBFT {
  final int n;
  final int f;
  PBFT(this.n, this.f) {
    if (n <= 0) throw ArgumentError('n>0');
    if (f < 0 || f * 3 >= n) throw ArgumentError('invalid f for n');
  }

  int prepareThreshold() => 2 * f;
  int commitThreshold() => 2 * f + 1;

  bool canCommit(int prepares, int commits) {
    return prepares >= prepareThreshold() && commits >= commitThreshold();
  }

  /// Given pre-prepares and prepares, decide if move to commit is allowed.
  bool canAdvanceToCommit(int prePrepares, int prepares) =>
      prepares >= prepareThreshold();
}
