/// Proof of Work (PoW) - production-minded simulation
///
/// A compact, auditable PoW miner framework that models the key engineering
/// concerns for production systems: pluggable hash function, target difficulty,
/// deterministic RNG for reproducible tests, mining loop with early exit,
/// and serialization. The implementation is intentionally small, easy to audit,
/// and suitable for unit tests and simulations rather than real cryptographic
/// mining.
///
/// Contract:
/// - Input: block data (string), difficulty (int, lower => harder), and a
///   hash function that maps (data+nonce) -> int (lower means "better").
/// - Output: a `MineResult` containing `nonce`, `hash` and `attempts`.
/// - Errors: throws ArgumentError on invalid difficulty or missing hash.
library;

import 'dart:math';

/// Result of a mining attempt.
class MineResult {
  final int nonce;
  final BigInt hash;
  final int attempts;
  final bool success;
  MineResult(this.nonce, this.hash, this.attempts, {this.success = false});
}

/// Hash function signature returning a BigInt-like value (lower = better).
typedef BigHash = BigInt Function(String data, int nonce);

/// Proof-of-Work helper built for deterministic simulation and testing.
///
/// Advanced features:
/// - accepts a pluggable `BigHash` function for arbitrary hash spaces
/// - `mine` supports an optional `shouldStop` callback for cancellation
/// - `verify` helper to validate a candidate against a target
/// - utilities to compute numeric `target` from compact difficulty bits
class ProofOfWork {
  final BigHash hashFn;
  final Random _rand;

  ProofOfWork({required this.hashFn, int? seed})
    : _rand = seed != null ? Random(seed) : Random();

  /// Mine `data` until `hash <= target` or `maxAttempts` reached.
  ///
  /// `shouldStop` is checked every iteration and may be used to cancel
  /// long-running mining from a caller (for example a UI or timeout).
  MineResult mine(
    String data,
    BigInt target, {
    int maxAttempts = 1000000,
    bool Function()? shouldStop,
  }) {
    if (target < BigInt.zero) throw ArgumentError('target must be >= 0');
    BigInt bestHash = BigInt.from(1) << 255; // large sentinel
    int bestNonce = 0;
    for (var i = 0; i < maxAttempts; i++) {
      if (shouldStop != null && shouldStop()) {
        return MineResult(bestNonce, bestHash, i, success: false);
      }
      final nonce = _rand.nextInt(1 << 30);
      final h = hashFn(data, nonce);
      if (h < bestHash) {
        bestHash = h;
        bestNonce = nonce;
      }
      if (h <= target) return MineResult(nonce, h, i + 1, success: true);
    }
    return MineResult(bestNonce, bestHash, maxAttempts, success: false);
  }

  /// Verify that a `nonce` for `data` meets the `target`.
  bool verify(String data, int nonce, BigInt target) =>
      hashFn(data, nonce) <= target;

  /// Compact bits -> target (toy implementation similar to Bitcoin's compact format).
  static BigInt targetFromCompact(int compact) {
    final size = (compact >> 24) & 0xff;
    final word = compact & 0x007fffff;
    BigInt result = BigInt.from(word) << (8 * (size - 3));
    return result;
  }
}
