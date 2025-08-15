/// Ad hoc On-Demand Distance Vector (AODV) - simulation-friendly core
///
/// This implementation provides a production-minded, simulation-friendly
/// AODV module. It focuses on determinism, clear APIs, and auditability.
/// - Nodes are identified by integer IDs.
/// - Route discovery uses RREQ/RREP flooding with sequence numbers.
/// - Routing table entries include next-hop, hop-count, and sequence numbers.
/// - The API is suitable for simulation frameworks: send, tick, and event hooks.
///
/// Note: This is a protocol-level simulator (no sockets). The node object can
/// be embedded into larger simulations or adapted to real network stacks.
library;

import 'dart:collection';

class AodvRouteEntry {
  final int destination;
  int nextHop;
  int hopCount;
  int seqNo;
  int lifetime; // ticks

  AodvRouteEntry(
    this.destination,
    this.nextHop,
    this.hopCount,
    this.seqNo,
    this.lifetime,
  );
}

class _RREQ {
  final int origin;
  final int dest;
  final int originSeq;
  final int destSeq;
  final int id; // rreq id
  final int ttl;
  _RREQ(
    this.origin,
    this.dest,
    this.originSeq,
    this.destSeq,
    this.id,
    this.ttl,
  );
}

class _RREP {
  final int origin;
  final int dest;
  final int hopCount;
  final int destSeq;
  _RREP(this.origin, this.dest, this.hopCount, this.destSeq);
}

/// Callback type invoked when a node delivers a payload to its destination.
typedef DeliveryCallback = void Function(int from, int to, dynamic payload);

class AodvNode {
  final int id;
  final Set<int> neighbors = {};
  final Map<int, AodvRouteEntry> routingTable = {};
  final Set<String> seenRREQ = {};
  final Map<int, int> rreqSeq = {}; // origin -> last rreq id
  int seqNo = 0;

  // message queue for simulation ticks
  final Queue<dynamic> _inbox = Queue<dynamic>();

  // hook to deliver messages to neighbor nodes (in-memory simulation)
  void Function(int from, int to, dynamic msg)? sendHook;

  DeliveryCallback? onDeliver;

  AodvNode(this.id);

  void addNeighbor(int nid) => neighbors.add(nid);

  void receive(int from, dynamic msg) {
    _inbox.add({'from': from, 'msg': msg});
  }

  void sendToNetwork(int to, dynamic msg) {
    if (sendHook == null) throw StateError('sendHook not configured');
    // best-effort delivery to neighbor
    sendHook!(id, to, msg);
  }

  void tick() {
    while (_inbox.isNotEmpty) {
      final item = _inbox.removeFirst();
      final from = item['from'] as int;
      final msg = item['msg'];
      if (msg is _RREQ) {
        _handleRREQ(from, msg);
      } else if (msg is _RREP) {
        _handleRREP(from, msg);
      } else if (msg is _Payload) {
        _handlePayload(from, msg);
      }
    }
    // age routes
    final toRemove = <int>[];
    for (var e in routingTable.values) {
      e.lifetime -= 1;
      if (e.lifetime <= 0) toRemove.add(e.destination);
    }
    for (var d in toRemove) {
      routingTable.remove(d);
    }
  }

  void _handlePayload(int from, _Payload p) {
    if (p.to == id) {
      onDeliver?.call(from, id, p.payload);
      return;
    }
    final route = routingTable[p.to];
    if (route == null) {
      // trigger route discovery
      _startRREQ(p.to);
      // buffer is beyond this simple implementation; drop or later extension
      return;
    }
    sendToNetwork(route.nextHop, p);
  }

  void _startRREQ(int dest) {
    seqNo += 1;
    final rid = rreqSeq[id] == null ? 1 : rreqSeq[id]! + 1;
    rreqSeq[id] = rid;
    final rreq = _RREQ(
      id,
      dest,
      seqNo,
      routingTable[dest]?.seqNo ?? 0,
      rid,
      10,
    );
    // broadcast to neighbors
    for (var nb in neighbors) {
      sendToNetwork(nb, rreq);
    }
  }

  void _handleRREQ(int from, _RREQ rreq) {
    final key = '${rreq.origin}-${rreq.id}';
    if (seenRREQ.contains(key)) return; // already processed
    seenRREQ.add(key);
    // create reverse route to origin
    routingTable[rreq.origin] = AodvRouteEntry(
      rreq.origin,
      from,
      1,
      rreq.originSeq,
      30,
    );
    if (rreq.dest == id) {
      // we are destination - send RREP back
      final rrep = _RREP(rreq.origin, id, 0, seqNo);
      sendToNetwork(from, rrep);
      return;
    }
    // if we have a fresh route to dest, reply
    final e = routingTable[rreq.dest];
    if (e != null && e.seqNo >= rreq.destSeq) {
      final rrep = _RREP(rreq.origin, rreq.dest, e.hopCount + 1, e.seqNo);
      sendToNetwork(from, rrep);
      return;
    }
    // otherwise forward RREQ (decrement ttl)
    if (rreq.ttl > 0) {
      final fwd = _RREQ(
        rreq.origin,
        rreq.dest,
        rreq.originSeq,
        rreq.destSeq,
        rreq.id,
        rreq.ttl - 1,
      );
      for (var nb in neighbors) {
        if (nb == from) continue;
        sendToNetwork(nb, fwd);
      }
    }
  }

  void _handleRREP(int from, _RREP rrep) {
    // install forward route
    routingTable[rrep.dest] = AodvRouteEntry(
      rrep.dest,
      from,
      rrep.hopCount + 1,
      rrep.destSeq,
      30,
    );
    if (rrep.origin == id) {
      // original requester
      return;
    }
    // forward RREP along reverse route
    final rev = routingTable[rrep.origin];
    if (rev != null) {
      sendToNetwork(rev.nextHop, rrep);
    }
  }

  /// High-level API: send payload to destination via discovered route.
  void send(int dest, dynamic payload) {
    final route = routingTable[dest];
    final p = _Payload(dest, payload);
    if (route == null) {
      _startRREQ(dest);
      return;
    }
    sendToNetwork(route.nextHop, p);
  }
}

class _Payload {
  final int to;
  final dynamic payload;
  _Payload(this.to, this.payload);
}
