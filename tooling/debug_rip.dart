import 'package:lunaris_engine/RoutingNET/rip_algorithm.dart';

void main() {
  final network = <String, Map<String, num>>{
    'A': {'B': 1, 'C': 4},
    'B': {'A': 1, 'C': 2, 'D': 5},
    'C': {'A': 4, 'B': 2, 'D': 1},
    'D': {'B': 5, 'C': 1, 'E': 3},
    'E': {'D': 3, 'F': 2},
    'F': {'E': 2, 'G': 4},
    'G': {'F': 4, 'H': 1},
    'H': {'G': 1},
  };

  print('Network topology:');
  for (final entry in network.entries) {
    print('${entry.key}: ${entry.value}');
  }

  final rip = RIPAlgorithm<String>();
  final routes = rip.computeRoutes(network, 'A');

  print('\nRouting table from A:');
  for (final route in routes.allRoutes) {
    print(
      '${route.destination}: cost=${route.cost}, nextHop=${route.nextHop}, direct=${route.isDirectlyConnected}',
    );
  }

  // Check specific routes
  final routeC = routes.getRoute('C');
  print('\nRoute to C:');
  print('  cost: ${routeC?.cost}');
  print('  nextHop: ${routeC?.nextHop}');
  print('  isDirectlyConnected: ${routeC?.isDirectlyConnected}');
}
