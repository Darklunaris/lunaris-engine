import 'package:lunaris_engine/RoutingNET/link_state_routing.dart';

List<String> prioritizeHosts(
  List<String> hosts, {
  String ordering = 'linkstate',
}) {
  if (hosts.isEmpty) return hosts;
  num linkCost(String a, String b) {
    final A = a.split('.');
    final B = b.split('.');
    if (A.length != 4 || B.length != 4) return 1000;
    if (A[0] == B[0] && A[1] == B[1] && A[2] == B[2]) return 1;
    if (A[0] == B[0] && A[1] == B[1]) return 5;
    return 20;
  }

  final Map<String, Map<String, num>> network = {};
  for (final a in hosts) {
    network[a] = {};
    for (final b in hosts) {
      if (a == b) continue;
      network[a]![b] = linkCost(a, b);
    }
  }

  try {
    if (ordering == 'heuristic') {
      final ordered =
          hosts.toList()..sort((x, y) {
            final xa = x.split('.').map(int.parse).toList();
            final ya = y.split('.').map(int.parse).toList();
            for (var i = 0; i < 4; i++) {
              final c = xa[i].compareTo(ya[i]);
              if (c != 0) return c;
            }
            return 0;
          });
      return ordered;
    }

    final routingTable = computeLinkStateRoutes<String>(network, hosts.first);
    final ordered =
        hosts.toList()..sort(
          (x, y) => (routingTable.getRoute(x)?.cost ?? 1e9).compareTo(
            routingTable.getRoute(y)?.cost ?? 1e9,
          ),
        );
    return ordered;
  } catch (_) {
    return hosts;
  }
}
