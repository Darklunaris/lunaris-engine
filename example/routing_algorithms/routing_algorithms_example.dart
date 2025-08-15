import 'package:lunaris_engine/RoutingNET/bgp_algorithm.dart';
import 'package:lunaris_engine/RoutingNET/ospf_algorithm.dart';
import 'package:lunaris_engine/RoutingNET/rip_algorithm.dart';
import 'package:lunaris_engine/RoutingNET/link_state_routing.dart';
import 'package:lunaris_engine/RoutingNET/distance_vector_routing.dart';

void main() {
  print('🌐 Routing Algorithms Examples\n');

  // Create a sample network topology
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

  // 🛣️ RIP (Routing Information Protocol)
  print('🛣️ RIP (Routing Information Protocol)');
  print('=' * 50);
  final rip = RIPAlgorithm<String>();
  final ripRoutes = rip.computeRoutes(network, 'A', maxHops: 15);

  print('Source Node: ${ripRoutes.sourceNode}');
  print('Total Routes: ${ripRoutes.routeCount}');
  print('Last Update: ${ripRoutes.lastUpdate}');

  // Show some sample routes
  final sampleDestinations = ['B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'];
  for (final dest in sampleDestinations) {
    final route = ripRoutes.getRoute(dest);
    if (route != null) {
      print(
        '  $dest → ${route.nextHop} (cost: ${route.cost}, direct: ${route.isDirectlyConnected})',
      );
    }
  }

  // Get RIP statistics
  final ripStats = rip.getRouteStatistics(ripRoutes);
  print('\nRIP Statistics:');
  print('  Average Cost: ${ripStats['averageCost']?.toStringAsFixed(2)}');
  print('  Max Cost: ${ripStats['maxCost']}');
  print('  Directly Connected: ${ripStats['directlyConnected']}');
  print('  Indirect Routes: ${ripStats['indirectRoutes']}');

  // 🌐 OSPF (Open Shortest Path First)
  print('\n🌐 OSPF (Open Shortest Path First)');
  print('=' * 50);
  final ospf = OSPFAlgorithm<String>();
  final ospfRoutes = ospf.computeRoutes(network, 'A', areaId: 0);

  print('Source Router: ${ospfRoutes.sourceRouter}');
  print('Total Routes: ${ospfRoutes.routeCount}');
  print('Total Areas: ${ospfRoutes.totalAreas}');
  print('Last Update: ${ospfRoutes.lastUpdate}');

  // Show some sample routes
  for (final dest in sampleDestinations) {
    final route = ospfRoutes.getRoute(dest);
    if (route != null) {
      print(
        '  $dest → ${route.nextHop} (cost: ${route.cost}, area: ${route.areaId})',
      );
    }
  }

  // Get OSPF statistics
  final ospfStats = ospf.getOSPFStatistics(ospfRoutes, {});
  print('\nOSPF Statistics:');
  print('  Average Cost: ${ospfStats['averageCost']?.toStringAsFixed(2)}');
  print('  Max Cost: ${ospfStats['maxCost']}');
  print('  Directly Connected: ${ospfStats['directlyConnected']}');
  print('  LSDB Size: ${ospfStats['lsdbSize']}');

  // 🌍 BGP (Border Gateway Protocol)
  print('\n🌍 BGP (Border Gateway Protocol)');
  print('=' * 50);

  // Create AS topology (simplified for example)
  final asTopology = <int, Map<int, num>>{
    100: {200: 1, 300: 1, 400: 1},
    200: {100: 1, 300: 1, 500: 1},
    300: {100: 1, 200: 1, 400: 1, 500: 1},
    400: {100: 1, 300: 1, 600: 1},
    500: {200: 1, 300: 1, 600: 1, 700: 1},
    600: {400: 1, 500: 1, 700: 1, 800: 1},
    700: {500: 1, 600: 1, 800: 1},
    800: {600: 1, 700: 1},
  };

  final bgp = BGPAlgorithm<int>();
  final bgpRoutes = bgp.computeRoutes(asTopology, 100);

  print('Source AS: ${bgpRoutes.sourceAS}');
  print('Total Routes: ${bgpRoutes.totalRoutes}');
  print('Total ASes: ${bgpRoutes.totalASes}');
  print('Last Update: ${bgpRoutes.lastUpdate}');

  // Show some sample AS routes
  final sampleASes = [200, 300, 400, 500, 600, 700, 800];
  for (final asNum in sampleASes) {
    final route = bgpRoutes.getBestRoute(asNum);
    if (route != null) {
      print(
        '  AS$asNum → AS${route.nextHop} (cost: ${route.asPathLength}, path: ${route.asPath})',
      );
    }
  }

  // Get BGP statistics
  final bgpStats = bgp.getBGPStatistics(bgpRoutes);
  print('\nBGP Statistics:');
  print(
    '  Average AS Path Length: ${bgpStats['averageASPathLength']?.toStringAsFixed(2)}',
  );
  print('  Max AS Path Length: ${bgpStats['maxASPathLength']}');
  print('  Directly Connected: ${bgpStats['directlyConnected']}');
  print('  Total Alternative Routes: ${bgpStats['totalAlternativeRoutes']}');

  // 🗺️ Link-State Routing
  print('\n🗺️ Link-State Routing');
  print('=' * 50);
  final lsr = LinkStateRoutingAlgorithm<String>();
  final lsrRoutes = lsr.computeRoutes(network, 'A');

  print('Source Node: ${lsrRoutes.sourceNode}');
  print('Total Routes: ${lsrRoutes.totalRoutes}');
  print('Total Nodes: ${lsrRoutes.totalNodes}');
  print('Last Update: ${lsrRoutes.lastUpdate}');

  // Show some sample routes with full paths
  for (final dest in sampleDestinations) {
    final route = lsrRoutes.getRoute(dest);
    if (route != null) {
      print(
        '  $dest → ${route.nextHop} (cost: ${route.cost}, path: ${route.path})',
      );
    }
  }

  // Get Link-State statistics
  final lsrStats = lsr.getLinkStateStatistics(lsrRoutes);
  print('\nLink-State Statistics:');
  print('  Average Cost: ${lsrStats['averageCost']?.toStringAsFixed(2)}');
  print('  Max Cost: ${lsrStats['maxCost']}');
  print(
    '  Average Hop Count: ${lsrStats['averageHopCount']?.toStringAsFixed(2)}',
  );
  print('  Network Density: ${lsrStats['networkDensity']?.toStringAsFixed(3)}');
  print('  Active Links: ${lsrStats['activeLinks']}');

  // 📡 Distance-Vector Routing
  print('\n📡 Distance-Vector Routing');
  print('=' * 50);
  final dvr = DistanceVectorRoutingAlgorithm<String>();
  final dvrRoutes = dvr.computeRoutes(network, 'A');

  print('Source Node: ${dvrRoutes.sourceNode}');
  print('Total Routes: ${dvrRoutes.totalRoutes}');
  print('Total Neighbors: ${dvrRoutes.totalNeighbors}');
  print('Last Update: ${dvrRoutes.lastUpdate}');

  // Show some sample routes
  for (final dest in sampleDestinations) {
    final route = dvrRoutes.getRoute(dest);
    if (route != null) {
      print(
        '  $dest → ${route.nextHop} (cost: ${route.cost}, hops: ${route.hopCount}, neighbor: ${route.advertisingNeighbor})',
      );
    }
  }

  // Get Distance-Vector statistics
  final dvrStats = dvr.getDistanceVectorStatistics(dvrRoutes);
  print('\nDistance-Vector Statistics:');
  print('  Average Cost: ${dvrStats['averageCost']?.toStringAsFixed(2)}');
  print('  Max Cost: ${dvrStats['maxCost']}');
  print(
    '  Average Hop Count: ${dvrStats['averageHopCount']?.toStringAsFixed(2)}',
  );
  print('  Valid Routes: ${dvrStats['validRoutes']}');
  print('  Convergence Status: ${dvrStats['convergenceStatus']}');

  // 🔄 Dynamic Updates Example
  print('\n🔄 Dynamic Updates Example');
  print('=' * 50);

  // Simulate a network change (link failure)
  final updatedNetwork = Map<String, Map<String, num>>.from(network);
  updatedNetwork['B']?.remove('C'); // Remove link B-C
  updatedNetwork['C']?.remove('B'); // Remove link C-B

  print('Simulating link failure: B ↔ C');

  // Recompute routes with updated network
  final updatedRipRoutes = rip.computeRoutes(updatedNetwork, 'A', maxHops: 15);
  final updatedOspfRoutes = ospf.computeRoutes(updatedNetwork, 'A', areaId: 0);
  final updatedLsrRoutes = lsr.computeRoutes(updatedNetwork, 'A');
  final updatedDvrRoutes = dvr.computeRoutes(updatedNetwork, 'A');

  print('Routes to C after link failure:');
  print('  RIP: ${updatedRipRoutes.getRoute('C')?.cost ?? 'unreachable'}');
  print('  OSPF: ${updatedOspfRoutes.getRoute('C')?.cost ?? 'unreachable'}');
  print(
    '  Link-State: ${updatedLsrRoutes.getRoute('C')?.cost ?? 'unreachable'}',
  );
  print(
    '  Distance-Vector: ${updatedDvrRoutes.getRoute('C')?.cost ?? 'unreachable'}',
  );

  // Show alternative path to C
  final alternativeRoute = updatedLsrRoutes.getRoute('C');
  if (alternativeRoute != null) {
    print('  Alternative path to C: ${alternativeRoute.path}');
  }

  // 📊 Performance Comparison
  print('\n📊 Performance Comparison');
  print('=' * 50);

  final algorithms = [
    {'name': 'RIP', 'routes': ripRoutes.routeCount, 'convergence': 'Slow'},
    {'name': 'OSPF', 'routes': ospfRoutes.routeCount, 'convergence': 'Fast'},
    {'name': 'BGP', 'routes': bgpRoutes.totalRoutes, 'convergence': 'Slow'},
    {
      'name': 'Link-State',
      'routes': lsrRoutes.totalRoutes,
      'convergence': 'Fast',
    },
    {
      'name': 'Distance-Vector',
      'routes': dvrRoutes.totalRoutes,
      'convergence': 'Medium',
    },
  ];

  print('Algorithm | Routes | Convergence');
  print('----------|--------|-------------');
  for (final algo in algorithms) {
    print(
      '${'${algo['name']}'.padRight(10)}${' | ${algo['routes']}'.padLeft(6)} | ${algo['convergence']}',
    );
  }

  print('\n✅ Routing algorithms demonstration completed!');
  print('\nKey Features Demonstrated:');
  print('• RIP: Hop-count based routing with 15-hop limit');
  print('• OSPF: Link-state routing with area support');
  print('• BGP: Path-vector routing with AS path information');
  print('• Link-State: Complete network topology with optimal paths');
  print('• Distance-Vector: Neighbor-based routing with loop prevention');
  print('• Dynamic updates: Route recalculation on topology changes');
  print('• Performance metrics: Route counts and convergence characteristics');
}
