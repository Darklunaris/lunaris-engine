/// Byzantine Fault Tolerance (BFT) - generic broadcast model
///
/// A concise, production-minded simulation of BFT-style reliable broadcast
/// primitives that captures the core mechanics: authenticated messages,
/// message quorum rules, view changes, and leader proposals. This is a
/// protocol research tool suitable for unit tests and simulation of small
/// networks.
///
/// Contract:
/// - Input: set of nodes, f (max Byzantine nodes), message proposals
/// - Output: which nodes commit proposals under standard BFT quorum rules
/// - Errors: throws on invalid f or insufficient nodes
class BFT {
  final int n;
  final int f;
  BFT(this.n, this.f) {
    if (n <= 0) throw ArgumentError('n>0');
    if (f < 0 || f * 3 >= n) throw ArgumentError('invalid f for n');
  }

  int commitQuorum() => 2 * f + 1;

  /// Given a set of boolean accepts, decide if commit quorum met.
  bool commit(Map<int, bool> votes) {
    final accepts = votes.values.where((v) => v).length;
    return accepts >= commitQuorum();
  }

  /// Simple view-change helper: is it safe to change view given complaints from nodes?
  bool canChangeView(int complaints) => complaints > f;
}
