import 'package:lunaris_engine/RoutingNET/distance_vector_routing.dart';

void main() {
  // Simple test network
  final network = <String, Map<String, num>>{
    'A': {'B': 1, 'C': 1},
    'B': {'A': 1, 'C': 1, 'D': 1},
    'C': {'A': 1, 'B': 1, 'D': 1},
    'D': {'B': 1, 'C': 1, 'E': 1},
    'E': {'D': 1, 'F': 1},
    'F': {'E': 1, 'G': 1},
    'G': {'F': 1, 'H': 1},
    'H': {'G': 1},
  };

  final algorithm = DistanceVectorRoutingAlgorithm<String>();

  print('Computing routes from A...');
  final routes = algorithm.computeRoutes(network, 'A');

  print('Total routes: ${routes.totalRoutes}');
  print('Routes:');
  for (final route in routes.routes.entries) {
    print(
      '  ${route.key}: cost=${route.value.cost}, nextHop=${route.value.nextHop}, isDirect=${route.value.isDirectlyConnected}',
    );
  }

  // Check specific routes
  print('\nChecking specific routes:');
  final routeE = routes.getRoute('E');
  final routeH = routes.getRoute('H');

  print(
    'Route to E: ${routeE != null ? "exists (cost: ${routeE.cost})" : "null"}',
  );
  print(
    'Route to H: ${routeH != null ? "exists (cost: ${routeH.cost})" : "null"}',
  );
}
