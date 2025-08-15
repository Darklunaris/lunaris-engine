import 'package:lunaris_engine/RoutingNET/link_state_routing.dart';

void main() {
  final network = <String, Map<String, num>>{
    'A': {'B': 10, 'C': 20, 'D': 15},
    'B': {'A': 10, 'C': 5, 'E': 12, 'F': 8},
    'C': {'A': 20, 'B': 5, 'D': 8, 'E': 7, 'G': 11},
    'D': {'A': 15, 'C': 8, 'F': 9, 'H': 6},
    'E': {'B': 12, 'C': 7, 'F': 11, 'G': 4, 'I': 13},
    'F': {'B': 8, 'D': 9, 'E': 11, 'H': 3, 'J': 7},
    'G': {'C': 11, 'E': 4, 'I': 9, 'K': 5},
    'H': {'D': 6, 'F': 3, 'J': 4, 'L': 8},
    'I': {'E': 13, 'G': 9, 'K': 6, 'M': 10},
    'J': {'F': 7, 'H': 4, 'L': 2, 'N': 12},
    'K': {'G': 5, 'I': 6, 'M': 8, 'O': 7},
    'L': {'H': 8, 'J': 2, 'N': 5, 'P': 9},
    'M': {'I': 10, 'K': 8, 'O': 4, 'Q': 11},
    'N': {'J': 12, 'L': 5, 'P': 3, 'R': 6},
    'O': {'K': 7, 'M': 4, 'Q': 9, 'S': 8},
    'P': {'L': 9, 'N': 3, 'R': 7, 'T': 5},
    'Q': {'M': 11, 'O': 9, 'S': 6, 'U': 4},
    'R': {'N': 6, 'P': 7, 'T': 10, 'V': 8},
    'S': {'O': 8, 'Q': 6, 'U': 12, 'W': 9},
    'T': {'P': 5, 'R': 10, 'V': 3, 'X': 7},
    'U': {'Q': 4, 'S': 12, 'W': 5, 'Y': 11},
    'V': {'R': 8, 'T': 3, 'X': 9, 'Z': 6},
    'W': {'S': 9, 'U': 5, 'Y': 8, 'Z': 4},
    'X': {'T': 7, 'V': 9, 'Z': 2},
    'Y': {'U': 11, 'W': 8, 'Z': 7},
    'Z': {'V': 6, 'W': 4, 'X': 2, 'Y': 7},
  };

  print('Network topology:');
  for (final entry in network.entries) {
    print('${entry.key}: ${entry.value}');
  }

  final lsr = LinkStateRoutingAlgorithm<String>();
  final routes = lsr.computeRoutes(network, 'A');

  print('\nRouting table from A:');
  for (final route in routes.allRoutes) {
    print(
      '${route.destination}: cost=${route.cost}, nextHop=${route.nextHop}, direct=${route.isDirectlyConnected}, path=${route.path}',
    );
  }

  final routeC = routes.getRoute('C');
  print('\nRoute to C:');
  print('  cost: ${routeC?.cost}');
  print('  nextHop: ${routeC?.nextHop}');
  print('  isDirectlyConnected: ${routeC?.isDirectlyConnected}');
  print('  path: ${routeC?.path}');
}
