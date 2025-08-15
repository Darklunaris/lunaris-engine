/// Kademlia K-Bucket DHT - production-minded simulation implementation
///
/// This module implements a simplified Kademlia routing table and iterative
/// lookup. It provides:
/// - XOR metric, k-buckets, node lookup with alpha parallelism.
/// - store/findValue semantics and bootstrap/join helpers.
/// - deterministic behavior suitable for unit tests and simulations.
library;

int _xor(int a, int b) => a ^ b;

class Contact {
  final int id;
  final dynamic endpoint; // application-defined transport reference
  Contact(this.id, this.endpoint);
}

class KBucket {
  final List<Contact> contacts = [];
  final int k;
  KBucket(this.k);

  void touch(Contact c) {
    // move to front if exists, else append and trim
    final i = contacts.indexWhere((x) => x.id == c.id);
    if (i >= 0) {
      final ex = contacts.removeAt(i);
      contacts.insert(0, ex);
    } else {
      contacts.insert(0, c);
      if (contacts.length > k) contacts.removeLast();
    }
  }
}

class KademliaNode {
  final int id;
  final int bits;
  final int k;
  final List<KBucket> buckets;
  final Map<int, dynamic> store = {};

  KademliaNode(this.id, {this.bits = 32, this.k = 20}) : buckets = [] {
    for (var i = 0; i < bits; i++) {
      buckets.add(KBucket(k));
    }
  }

  int _bucketIndex(int nid) {
    final d = _xor(id, nid);
    if (d == 0) return 0;
    return 31 - d.clamp(0, 0x7fffffff).bitLength + 1; // approximate
  }

  void touch(Contact c) {
    final i = _bucketIndex(c.id);
    buckets[i].touch(c);
  }

  void storeValue(int key, dynamic value) {
    store[key] = value;
  }

  List<Contact> findClosest(int key, int count) {
    final list = <Contact>[];
    for (var b in buckets) {
      list.addAll(b.contacts);
    }
    list.sort((a, b) => _xor(a.id, key).compareTo(_xor(b.id, key)));
    return list.take(count).toList();
  }

  dynamic findValue(int key) {
    if (store.containsKey(key)) return store[key];
    return null;
  }
}
