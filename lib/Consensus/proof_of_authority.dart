/// Proof of Authority (PoA) - authority-based block production
///
/// A compact PoA scheduler for permissioned networks. This module demonstrates
/// validator rotation, authority list management, and deterministic leader
/// selection via round-robin or weighted round-robin. It is intended for
/// protocol simulations and unit tests rather than production ledger code.
///
/// Contract:
/// - Input: list of authorities and optional weights
/// - Output: leader for a given slot
/// - Errors: throws on empty authority list
library;

import 'dart:math';

class Authority {
  final String id;
  int weight;
  Authority(this.id, {this.weight = 1}) {
    if (weight <= 0) throw ArgumentError('weight>0');
  }
  Map<String, dynamic> toMap() => {'id': id, 'weight': weight};
}

/// PoA helper with rotation policies and deterministic leader derivation.
class PoA {
  final List<Authority> authorities;
  final Set<String> allowlist = {};

  PoA(this.authorities) {
    if (authorities.isEmpty) throw ArgumentError('authorities required');
    for (var a in authorities) {
      allowlist.add(a.id);
    }
  }

  /// Add an authority to the allowlist (for permissioned networks).
  void addAuthority(Authority a) {
    authorities.add(a);
    allowlist.add(a.id);
  }

  /// Remove authority by id (soft-remove from allowlist and authority list).
  void removeAuthority(String id) {
    authorities.removeWhere((a) => a.id == id);
    allowlist.remove(id);
  }

  /// Deterministic leader selection using weighted round-robin seeded by slot.
  String leaderForSlot(int slot) {
    final totalWeight = authorities.fold<int>(0, (a, b) => a + b.weight);
    if (totalWeight <= 0) throw StateError('total weight <= 0');
    final rnd = Random(slot ^ authorities.length);
    var pick = rnd.nextInt(totalWeight);
    for (var a in authorities) {
      if (pick < a.weight) return a.id;
      pick -= a.weight;
    }
    return authorities.last.id;
  }
}
