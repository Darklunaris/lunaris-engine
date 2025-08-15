/// Dynamic Source Routing (DSR) - simulation-level implementation
///
/// DSR emphasizes source routing and route caches. This module provides a
/// high-quality, simulation-oriented DSR implementation:
/// - Source routes are embedded in packets.
/// - Nodes maintain route caches and learn by passive observation.
/// - Route discovery uses route request/reply with full path recording.
///
/// The API is designed to be embedded into network simulators and adapted to
/// real stacks if needed. Deterministic behavior and clear hooks are provided.
library;

import 'dart:collection';

class DsrNode {
  final int id;
  final Set<int> neighbors = {};
  final Map<int, List<int>> routeCache = {};
  final Queue<dynamic> _inbox = Queue<dynamic>();
  void Function(int from, int to, dynamic msg)? sendHook;
  void Function(int from, int to, dynamic payload)? onDeliver;
  int _rreqId = 0;
  final Set<String> seenRREQ = {};

  DsrNode(this.id);

  void addNeighbor(int nid) => neighbors.add(nid);
  void receive(int from, dynamic msg) {
    _inbox.add({'from': from, 'msg': msg});
  }

  void tick() {
    while (_inbox.isNotEmpty) {
      final item = _inbox.removeFirst();
      final from = item['from'] as int;
      final msg = item['msg'];
      if (msg is _DsrRREQ) {
        _handleRREQ(from, msg);
      } else if (msg is _DsrRREP) {
        _handleRREP(from, msg);
      } else if (msg is _DsrPayload) {
        _handlePayload(from, msg);
      }
    }
  }

  void _sendRaw(int to, dynamic msg) {
    if (sendHook == null) throw StateError('sendHook not configured');
    sendHook!(id, to, msg);
  }

  void send(int dest, dynamic payload) {
    final path = routeCache[dest];
    if (path != null) {
      // create source routed packet
      final pkt = _DsrPayload(path, payload);
      final next = path.length > 1 ? path[1] : dest;
      _sendRaw(next, pkt);
      return;
    }
    // start route discovery
    _rreqId += 1;
    final rreq = _DsrRREQ(id, dest, _rreqId, [id]);
    for (var nb in neighbors) {
      _sendRaw(nb, rreq);
    }
  }

  void _handlePayload(int from, _DsrPayload p) {
    final path = p.path;
    final idx = path.indexOf(id);
    if (idx == path.length - 1) {
      // reached destination
      onDeliver?.call(from, id, p.payload);
      // learn route
      routeCache[path.first] = path;
      return;
    }
    final next = path[idx + 1];
    // learn route for source
    routeCache[path.first] = path;
    _sendRaw(next, p);
  }

  void _handleRREQ(int from, _DsrRREQ rreq) {
    final key = '${rreq.origin}-${rreq.id}';
    if (seenRREQ.contains(key)) return;
    seenRREQ.add(key);
    // append ourselves
    final newPath = List<int>.from(rreq.path)..add(id);
    if (id == rreq.dest) {
      // reply with full path back to origin
      final rep = _DsrRREP(id, rreq.origin, newPath.reversed.toList());
      // send back along reverse path
      if (newPath.length >= 2) {
        final next = newPath[newPath.length - 2];
        _sendRaw(next, rep);
      }
      return;
    }
    // forward RREQ to neighbors except the one we received from
    for (var nb in neighbors) {
      if (nb == from) continue;
      final frwd = _DsrRREQ(rreq.origin, rreq.dest, rreq.id, newPath);
      _sendRaw(nb, frwd);
    }
  }

  void _handleRREP(int from, _DsrRREP rep) {
    // if this node is the origin of the reply path, install route
    if (rep.to == id) {
      final path = List<int>.from(rep.path.reversed);
      routeCache[path.last] = path;
      return;
    }
    // forward along the reply path
    final idx = rep.path.indexOf(id);
    if (idx > 0) {
      final next = rep.path[idx - 1];
      _sendRaw(next, rep);
    }
  }
}

class _DsrRREQ {
  final int origin;
  final int dest;
  final int id;
  final List<int> path;
  _DsrRREQ(this.origin, this.dest, this.id, this.path);
}

class _DsrRREP {
  final int from;
  final int to;
  final List<int> path;
  _DsrRREP(this.from, this.to, this.path);
}

class _DsrPayload {
  final List<int> path;
  final dynamic payload;
  _DsrPayload(this.path, this.payload);
}
