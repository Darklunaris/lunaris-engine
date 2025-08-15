# 🌐 Routing Algorithms

This library provides a comprehensive collection of production-ready routing algorithms for network infrastructure and distributed systems. All algorithms are implemented as generic, type-safe implementations that can work with any data type.

## 📋 Overview

The routing algorithms library includes five major routing protocols and algorithms:

1. **RIP (Routing Information Protocol)** - Distance-vector routing based on hop counts
2. **OSPF (Open Shortest Path First)** - Link-state routing using Dijkstra's algorithm
3. **BGP (Border Gateway Protocol)** - Path-vector routing for inter-domain routing
4. **Link-State Routing** - Complete network topology with optimal path computation
5. **Distance-Vector Routing** - Neighbor-based routing with loop prevention

## 🚀 Features

- **Generic Implementation**: All algorithms work with any data type `T`
- **Production Ready**: Enterprise-grade implementations with comprehensive error handling
- **High Performance**: Optimized algorithms for large-scale networks
- **Comprehensive Testing**: Extensive test coverage with edge case handling
- **Real-time Updates**: Support for dynamic network topology changes
- **Statistics & Monitoring**: Built-in metrics and performance analysis
- **Validation**: Comprehensive input validation and consistency checking

## 📚 Algorithm Details

### 🛣️ RIP (Routing Information Protocol)

**Purpose**: Interior Gateway Protocol for small to medium networks
**Algorithm**: Distance-vector routing using Bellman-Ford
**Convergence**: Slow but guaranteed
**Hop Limit**: 15 hops maximum

```dart
import 'package:lunaris_engine/routing_algorithms/rip_algorithm.dart';

final network = <String, Map<String, num>>{
  'A': {'B': 1, 'C': 4},
  'B': {'A': 1, 'C': 2, 'D': 5},
  'C': {'A': 4, 'B': 2, 'D': 1},
  'D': {'B': 5, 'C': 1},
};

final rip = RIPAlgorithm<String>();
final routes = rip.computeRoutes(network, 'A', maxHops: 15);

// Get route to specific destination
final routeToD = routes.getRoute('D');
print('Route to D: ${routeToD?.cost} hops via ${routeToD?.nextHop}');

// Get statistics
final stats = rip.getRouteStatistics(routes);
print('Average cost: ${stats['averageCost']}');
```

**Key Features**:
- Configurable update intervals and timeouts
- Automatic garbage collection of stale routes
- Support for route advertisements from neighbors
- Comprehensive validation and error handling

### 🌐 OSPF (Open Shortest Path First)

**Purpose**: Interior Gateway Protocol for large enterprise networks
**Algorithm**: Link-state routing using Dijkstra's shortest path
**Convergence**: Fast with immediate topology updates
**Area Support**: Hierarchical routing with areas

```dart
import 'package:lunaris_engine/routing_algorithms/ospf_algorithm.dart';

final ospf = OSPFAlgorithm<String>();
final routes = ospf.computeRoutes(network, 'A', areaId: 0);

// Get routes in specific area
final areaRoutes = routes.getRoutesInArea(0);

// Get routes by type
final routerRoutes = routes.getRoutesByType(LinkStateType.routerLSA);

// Get OSPF statistics
final stats = ospf.getOSPFStatistics(routes, {});
print('LSDB size: ${stats['lsdbSize']}');
```

**Key Features**:
- Link-state database (LSDB) management
- Area-based hierarchical routing
- Multiple link-state advertisement types
- Fast convergence on topology changes

### 🌍 BGP (Border Gateway Protocol)

**Purpose**: Exterior Gateway Protocol for inter-domain routing
**Algorithm**: Path-vector routing with policy-based selection
**Convergence**: Slow due to policy complexity
**AS Support**: Full autonomous system number support

```dart
import 'package:lunaris_engine/routing_algorithms/bgp_algorithm.dart';

final asTopology = <int, Map<int, num>>{
  100: {200: 1, 300: 1},
  200: {100: 1, 400: 1},
  300: {100: 1, 400: 1},
  400: {200: 1, 300: 1},
};

final bgp = BGPAlgorithm<int>();
final routes = bgp.computeRoutes(asTopology, 100);

// Get best route to destination AS
final routeToAS400 = routes.getBestRoute(400);
print('Route to AS400: ${routeToAS400?.asPath}');

// Get alternative routes
final alternatives = routes.getAlternativeRoutes(400);

// Apply routing policies
final policies = {
  'communities': {
    'NO_EXPORT': {'action': 'prefer', 'value': 10}
  }
};
final policyRoutes = bgp.computeRoutes(asTopology, 100, policies: policies);
```

**Key Features**:
- Policy-based route selection
- AS path loop detection
- Community-based routing policies
- Comprehensive BGP attributes support
- Alternative route management

### 🗺️ Link-State Routing

**Purpose**: Complete network topology with optimal path computation
**Algorithm**: Dijkstra's shortest path with full network visibility
**Convergence**: Immediate on topology changes
**Network View**: Complete network topology

```dart
import 'package:lunaris_engine/routing_algorithms/link_state_routing.dart';

final lsr = LinkStateRoutingAlgorithm<String>();
final routes = lsr.computeRoutes(network, 'A');

// Get complete path to destination
final routeToH = routes.getRoute('H');
print('Path to H: ${routeToH?.path}');

// Get routes by hop count
final twoHopRoutes = routes.getRoutesByHopCount(2);

// Apply topology optimizations
final optimizations = {
  'linkCostMultiplier': 1.5,
  'disableLinks': ['C'],
};
final optimizedRoutes = lsr.computeRoutes(
  network, 
  'A', 
  topologyOptimizations: optimizations
);

// Handle topology changes
final topologyChanges = [
  LinkStateEntry<String>(
    sourceNode: 'B',
    targetNode: 'C',
    linkCost: 20.0,
    status: LinkStateStatus.failed,
    lastUpdate: DateTime.now(),
    sequenceNumber: 2,
  ),
];
final updatedRoutes = lsr.updateFromTopologyChanges(
  routes, 
  topologyChanges, 
  network
);
```

**Key Features**:
- Complete network topology visibility
- Optimal path computation using Dijkstra's algorithm
- Topology optimization and path compression
- Real-time topology change handling
- Network density and performance metrics

### 📡 Distance-Vector Routing

**Purpose**: Neighbor-based routing with loop prevention
**Algorithm**: Bellman-Ford with split horizon and poison reverse
**Convergence**: Medium speed with guaranteed convergence
**Update Strategy**: Neighbor-only information sharing

```dart
import 'package:lunaris_engine/routing_algorithms/distance_vector_routing.dart';

final dvr = DistanceVectorRoutingAlgorithm<String>();
final routes = dvr.computeRoutes(network, 'A');

// Get routes from specific neighbor
final routesFromB = routes.getRoutesFromNeighbor('B');

// Get valid (non-stale) routes
final validRoutes = routes.validRoutes;

// Process neighbor updates
final advertisement = NeighborAdvertisement<String>(
  neighbor: 'X',
  distanceVector: <String, num>{'X': 0, 'Y': 2},
  timestamp: DateTime.now(),
  sequenceNumber: 1,
);
final updatedRoutes = dvr.processNeighborUpdate(
  routes, 
  advertisement, 
  network
);

// Clean up stale routes
final cleanedRoutes = dvr.cleanupStaleRoutes(routes, DateTime.now());
```

**Key Features**:
- Split horizon and poison reverse loop prevention
- Neighbor advertisement management
- Automatic route timeout and cleanup
- Convergence status monitoring
- Configurable update intervals

## 🔧 Configuration Options

All algorithms support extensive configuration:

```dart
// RIP Configuration
final rip = RIPAlgorithm<String>(
  updateInterval: Duration(seconds: 30),
  routeTimeout: Duration(seconds: 180),
  garbageCollectionTimeout: Duration(seconds: 120),
  maxIterations: 100,
);

// OSPF Configuration
final ospf = OSPFAlgorithm<String>(
  lsaInterval: Duration(seconds: 30),
  lsaExpiry: Duration(seconds: 3600),
  maxIterations: 1000,
  enableAreas: true,
);

// BGP Configuration
final bgp = BGPAlgorithm<int>(
  updateInterval: Duration(seconds: 30),
  routeTimeout: Duration(seconds: 180),
  maxIterations: 1000,
  enablePolicyBasedSelection: true,
);

// Link-State Configuration
final lsr = LinkStateRoutingAlgorithm<String>(
  updateInterval: Duration(seconds: 10),
  linkTimeout: Duration(seconds: 60),
  enableTopologyOptimization: true,
  enablePathCompression: true,
);

// Distance-Vector Configuration
final dvr = DistanceVectorRoutingAlgorithm<String>(
  updateInterval: Duration(seconds: 30),
  routeTimeout: Duration(seconds: 180),
  maxIterations: 100,
  enableSplitHorizon: true,
  enablePoisonReverse: true,
  enableTriggeredUpdates: true,
);
```

## 📊 Performance Characteristics

| Algorithm | Time Complexity | Space Complexity | Convergence | Use Case |
|-----------|----------------|------------------|-------------|----------|
| RIP | O(VE) per iteration | O(V²) | Slow | Small networks |
| OSPF | O(V² + E) | O(V²) | Fast | Enterprise networks |
| BGP | O(V²) | O(V²) | Slow | Inter-domain routing |
| Link-State | O(V² + E) | O(V²) | Immediate | Complete topology |
| Distance-Vector | O(VE) per iteration | O(V²) | Medium | Neighbor-based |

## 🧪 Testing and Validation

All algorithms include comprehensive testing:

```bash
# Run all routing algorithm tests
dart test test/routing_algorithms/

# Run specific algorithm tests
dart test test/routing_algorithms/rip_algorithm_test.dart
dart test test/routing_algorithms/ospf_algorithm_test.dart
dart test test/routing_algorithms/bgp_algorithm_test.dart
dart test test/routing_algorithms/link_state_routing_test.dart
dart test test/routing_algorithms/distance_vector_routing_test.dart
```

## 📖 Examples

See the comprehensive examples in `example/routing_algorithms/routing_algorithms_example.dart` for:

- Basic usage of all algorithms
- Dynamic network updates
- Performance comparisons
- Statistics and monitoring
- Error handling and validation

## 🚨 Error Handling

All algorithms include comprehensive error handling:

```dart
try {
  final routes = algorithm.computeRoutes(network, sourceNode);
  // Process routes
} on ArgumentError catch (e) {
  print('Invalid input: $e');
} catch (e) {
  print('Unexpected error: $e');
}

// Validate routing tables
final errors = algorithm.validateRoutingTable(routes, network);
if (errors.isNotEmpty) {
  print('Validation errors: $errors');
}
```

## 🔍 Monitoring and Statistics

All algorithms provide comprehensive statistics:

```dart
// Get algorithm-specific statistics
final ripStats = rip.getRouteStatistics(routes);
final ospfStats = ospf.getOSPFStatistics(routes, {});
final bgpStats = bgp.getBGPStatistics(routes);
final lsrStats = lsr.getLinkStateStatistics(routes);
final dvrStats = dvr.getDistanceVectorStatistics(routes);

// Common metrics include:
// - Total routes and nodes
// - Average/max/min costs
// - Convergence status
// - Performance indicators
// - Error counts
```

## 🏗️ Architecture

The routing algorithms are designed with a clean, extensible architecture:

- **Core Classes**: Base routing table and route entry classes
- **Algorithm Implementations**: Specific routing protocol implementations
- **Utility Functions**: Convenience functions for common operations
- **Validation**: Comprehensive input and state validation
- **Statistics**: Built-in monitoring and performance metrics

## 🔄 Dynamic Updates

All algorithms support real-time network updates:

```dart
// Handle topology changes
final updatedRoutes = algorithm.updateFromTopologyChanges(
  currentRoutes,
  topologyChanges,
  network
);

// Process neighbor updates
final updatedRoutes = algorithm.processNeighborUpdate(
  currentRoutes,
  advertisement,
  network
);

// Clean up stale information
final cleanedRoutes = algorithm.cleanupStaleRoutes(
  routes,
  DateTime.now()
);
```

## 📈 Best Practices

1. **Choose the Right Algorithm**: Consider network size, convergence requirements, and administrative overhead
2. **Configure Timeouts**: Set appropriate timeouts based on network characteristics
3. **Monitor Performance**: Use built-in statistics to monitor algorithm performance
4. **Handle Errors**: Implement proper error handling for production use
5. **Validate Inputs**: Always validate network topology and parameters
6. **Test Thoroughly**: Use the comprehensive test suite to verify correctness

## 🤝 Contributing

When contributing to routing algorithms:

1. Maintain the generic `T` type parameter
2. Follow the existing documentation style
3. Include comprehensive tests
4. Add proper error handling
5. Update this documentation
6. Ensure performance characteristics are documented

## 📄 License

This routing algorithms library is part of the lunaris_engine package and follows the same licensing terms.
