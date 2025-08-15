/// 🛣️ RIP (Routing Information Protocol) Algorithm
///
/// Implements the Routing Information Protocol based on hop distances for
/// dynamic routing table computation. RIP uses the Bellman-Ford algorithm
/// to find shortest paths based on hop count (distance vector routing).
///
/// - **Time Complexity**: O(VE) per iteration, where V is vertices, E is edges
/// - **Space Complexity**: O(V²) for routing tables
/// - **Convergence**: Guaranteed to converge in finite iterations
/// - **Maximum Hops**: 15 (RIP limitation to prevent count-to-infinity)
/// - **Update Frequency**: Configurable (typically 30 seconds)
///
/// The algorithm maintains routing tables with destination, next hop,
/// cost (hop count), and timestamp information for each route.
///
/// Example:
/// ```dart
/// final network = <String, Map<String, num>>{
///   'A': {'B': 1, 'C': 1},
///   'B': {'A': 1, 'D': 1},
///   'C': {'A': 1, 'D': 1},
///   'D': {'B': 1, 'C': 1},
/// };
/// final rip = RIPAlgorithm<String>();
/// final routes = rip.computeRoutes(network, 'A');
/// // Result: Complete routing table from node A
/// ```
library;

/// Represents a routing table entry with destination and routing information
class RouteEntry<T> {
  final T destination;
  final T? nextHop;
  final int cost;
  final DateTime lastUpdate;
  final bool isDirectlyConnected;

  const RouteEntry({
    required this.destination,
    this.nextHop,
    required this.cost,
    required this.lastUpdate,
    required this.isDirectlyConnected,
  });

  /// Creates a copy with updated values
  RouteEntry<T> copyWith({
    T? destination,
    T? nextHop,
    int? cost,
    DateTime? lastUpdate,
    bool? isDirectlyConnected,
  }) {
    return RouteEntry<T>(
      destination: destination ?? this.destination,
      nextHop: nextHop ?? this.nextHop,
      cost: cost ?? this.cost,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isDirectlyConnected: isDirectlyConnected ?? this.isDirectlyConnected,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteEntry<T> &&
          runtimeType == other.runtimeType &&
          destination == other.destination &&
          nextHop == other.nextHop &&
          cost == other.cost;

  @override
  int get hashCode => Object.hash(destination, nextHop, cost);

  @override
  String toString() =>
      'RouteEntry(dest: $destination, nextHop: $nextHop, cost: $cost, direct: $isDirectlyConnected)';
}

/// Represents a complete routing table for a node
class RoutingTable<T> {
  final T sourceNode;
  final Map<T, RouteEntry<T>> routes;
  final DateTime lastUpdate;

  const RoutingTable({
    required this.sourceNode,
    required this.routes,
    required this.lastUpdate,
  });

  /// Gets the route to a specific destination
  RouteEntry<T>? getRoute(T destination) => routes[destination];

  /// Gets all routes as a list
  List<RouteEntry<T>> get allRoutes => routes.values.toList();

  /// Gets the number of routes
  int get routeCount => routes.length;

  /// Gets routes with cost less than or equal to maxCost
  List<RouteEntry<T>> getRoutesByCost(int maxCost) =>
      routes.values.where((route) => route.cost <= maxCost).toList();

  /// Gets directly connected routes
  List<RouteEntry<T>> get directlyConnectedRoutes =>
      routes.values.where((route) => route.isDirectlyConnected).toList();

  /// Gets routes that need updating (older than threshold)
  List<RouteEntry<T>> getStaleRoutes(Duration threshold) {
    final cutoff = DateTime.now().subtract(threshold);
    return routes.values
        .where((route) => route.lastUpdate.isBefore(cutoff))
        .toList();
  }

  @override
  String toString() =>
      'RoutingTable(source: $sourceNode, routes: ${routes.length}, lastUpdate: $lastUpdate)';
}

/// RIP Algorithm implementation with configurable parameters
class RIPAlgorithm<T> {
  static const int _maxHops = 15; // RIP maximum hop count
  static const Duration _defaultUpdateInterval = Duration(seconds: 30);
  static const Duration _routeTimeout = Duration(seconds: 180);
  static const Duration _garbageCollectionTimeout = Duration(seconds: 120);

  final Duration updateInterval;
  final Duration routeTimeout;
  final Duration garbageCollectionTimeout;
  final int maxIterations;

  /// Creates a RIP algorithm instance with configurable parameters
  ///
  /// [updateInterval] - How often routing tables are updated
  /// [routeTimeout] - How long before a route is considered stale
  /// [garbageCollectionTimeout] - How long before stale routes are removed
  /// [maxIterations] - Maximum iterations for convergence
  const RIPAlgorithm({
    this.updateInterval = _defaultUpdateInterval,
    this.routeTimeout = _routeTimeout,
    this.garbageCollectionTimeout = _garbageCollectionTimeout,
    this.maxIterations = 100,
  });

  /// Computes complete routing table for a source node
  ///
  /// [network] - Network topology as adjacency list
  /// [sourceNode] - Source node for routing table computation
  /// [maxHops] - Maximum hop count (default: 15 for RIP)
  ///
  /// Returns a complete routing table with all reachable destinations
  ///
  /// Throws [ArgumentError] if source node doesn't exist in network
  RoutingTable<T> computeRoutes(
    Map<T, Map<T, num>> network,
    T sourceNode, {
    int maxHops = _maxHops,
  }) {
    // Input validation
    if (!network.containsKey(sourceNode)) {
      throw ArgumentError('Source node $sourceNode not found in network');
    }

    // Initialize routing table with direct connections
    final routes = <T, RouteEntry<T>>{};
    final now = DateTime.now();

    // Add source node to itself
    routes[sourceNode] = RouteEntry<T>(
      destination: sourceNode,
      nextHop: null,
      cost: 0,
      lastUpdate: now,
      isDirectlyConnected: true,
    );

    // Add directly connected neighbors
    final directNeighbors = network[sourceNode]!;
    for (final neighbor in directNeighbors.keys) {
      routes[neighbor] = RouteEntry<T>(
        destination: neighbor,
        nextHop: neighbor,
        cost: 1,
        lastUpdate: now,
        isDirectlyConnected: true,
      );
    }

    // Bellman-Ford iterations for route discovery
    for (int iteration = 0; iteration < maxIterations; iteration++) {
      bool hasChanges = false;

      // Process each node in the network
      for (final node in network.keys) {
        if (node == sourceNode) continue;

        final neighbors = network[node]!;
        for (final neighbor in neighbors.keys) {
          // Skip if neighbor is not in our routing table
          if (!routes.containsKey(neighbor)) continue;

          final neighborRoute = routes[neighbor]!;
          final linkCost = neighbors[neighbor]!;
          final newCost = neighborRoute.cost + linkCost.toInt();

          // Check if we found a better route
          if (!routes.containsKey(node) || newCost < routes[node]!.cost) {
            if (newCost <= maxHops) {
              routes[node] = RouteEntry<T>(
                destination: node,
                nextHop: neighbor,
                cost: newCost,
                lastUpdate: now,
                isDirectlyConnected: false,
              );
              hasChanges = true;
            }
          }
        }
      }

      // If no changes in this iteration, we've converged
      if (!hasChanges) break;
    }

    return RoutingTable<T>(
      sourceNode: sourceNode,
      routes: Map.unmodifiable(routes),
      lastUpdate: now,
    );
  }

  /// Updates routing table based on received route advertisements
  ///
  /// [currentTable] - Current routing table
  /// [advertisements] - Route advertisements from neighbors
  /// [neighborCost] - Cost to reach the advertising neighbor
  ///
  /// Returns updated routing table with new routes
  RoutingTable<T> updateRoutes(
    RoutingTable<T> currentTable,
    Map<T, RouteEntry<T>> advertisements,
    T neighbor,
    int neighborCost,
  ) {
    final updatedRoutes = Map<T, RouteEntry<T>>.from(currentTable.routes);
    final now = DateTime.now();
    bool hasChanges = false;

    for (final entry in advertisements.entries) {
      final dest = entry.key;
      final advRoute = entry.value;
      final totalCost = advRoute.cost + neighborCost;

      // Skip if cost exceeds maximum hops
      if (totalCost > _maxHops) continue;

      // Check if we have a better route
      if (!updatedRoutes.containsKey(dest) ||
          totalCost < updatedRoutes[dest]!.cost) {
        updatedRoutes[dest] = RouteEntry<T>(
          destination: dest,
          nextHop: neighbor,
          cost: totalCost,
          lastUpdate: now,
          isDirectlyConnected: false,
        );
        hasChanges = true;
      }
    }

    // Update neighbor route if we have a better path
    if (!updatedRoutes.containsKey(neighbor) ||
        neighborCost < updatedRoutes[neighbor]!.cost) {
      updatedRoutes[neighbor] = RouteEntry<T>(
        destination: neighbor,
        nextHop: neighbor,
        cost: neighborCost,
        lastUpdate: now,
        isDirectlyConnected: true,
      );
      hasChanges = true;
    }

    return RoutingTable<T>(
      sourceNode: currentTable.sourceNode,
      routes: Map.unmodifiable(updatedRoutes),
      lastUpdate: hasChanges ? now : currentTable.lastUpdate,
    );
  }

  /// Removes stale routes and performs garbage collection
  ///
  /// [routingTable] - Current routing table
  /// [currentTime] - Current time for comparison
  ///
  /// Returns cleaned routing table with stale routes removed
  RoutingTable<T> cleanupStaleRoutes(
    RoutingTable<T> routingTable,
    DateTime currentTime,
  ) {
    final validRoutes = <T, RouteEntry<T>>{};
    final cutoff = currentTime.subtract(garbageCollectionTimeout);

    for (final entry in routingTable.routes.entries) {
      final dest = entry.key;
      final route = entry.value;

      // Keep directly connected routes and recent routes
      if (route.isDirectlyConnected || route.lastUpdate.isAfter(cutoff)) {
        validRoutes[dest] = route;
      }
    }

    return RoutingTable<T>(
      sourceNode: routingTable.sourceNode,
      routes: Map.unmodifiable(validRoutes),
      lastUpdate: currentTime,
    );
  }

  /// Gets route statistics for monitoring and analysis
  ///
  /// [routingTable] - Routing table to analyze
  ///
  /// Returns map with various statistics
  Map<String, dynamic> getRouteStatistics(RoutingTable<T> routingTable) {
    final routes = routingTable.routes.values;
    final costs = routes.map((r) => r.cost).toList();
    final updateTimes = routes.map((r) => r.lastUpdate).toList();

    return {
      'totalRoutes': routes.length,
      'directlyConnected': routes.where((r) => r.isDirectlyConnected).length,
      'indirectRoutes': routes.where((r) => !r.isDirectlyConnected).length,
      'averageCost':
          costs.isEmpty ? 0.0 : costs.reduce((a, b) => a + b) / costs.length,
      'maxCost': costs.isEmpty ? 0 : costs.reduce((a, b) => a > b ? a : b),
      'minCost': costs.isEmpty ? 0 : costs.reduce((a, b) => a < b ? a : b),
      'oldestUpdate':
          updateTimes.isEmpty
              ? null
              : updateTimes.reduce((a, b) => a.isBefore(b) ? a : b),
      'newestUpdate':
          updateTimes.isEmpty
              ? null
              : updateTimes.reduce((a, b) => a.isAfter(b) ? a : b),
      'staleRoutes':
          routes
              .where(
                (r) => DateTime.now().difference(r.lastUpdate) > routeTimeout,
              )
              .length,
    };
  }

  /// Checks if routing table needs updating based on time intervals
  ///
  /// [routingTable] - Current routing table
  /// [currentTime] - Current time for comparison
  ///
  /// Returns true if update is needed
  bool needsUpdate(RoutingTable<T> routingTable, DateTime currentTime) {
    return currentTime.difference(routingTable.lastUpdate) >= updateInterval;
  }

  /// Validates routing table consistency and integrity
  ///
  /// [routingTable] - Routing table to validate
  /// [network] - Network topology for validation
  ///
  /// Returns list of validation errors (empty if valid)
  List<String> validateRoutingTable(
    RoutingTable<T> routingTable,
    Map<T, Map<T, num>> network,
  ) {
    final errors = <String>[];

    // Check if source node exists in network
    if (!network.containsKey(routingTable.sourceNode)) {
      errors.add('Source node ${routingTable.sourceNode} not found in network');
    }

    // Check for invalid costs
    for (final route in routingTable.routes.values) {
      if (route.cost < 0) {
        errors.add(
          'Invalid cost ${route.cost} for destination ${route.destination}',
        );
      }
      if (route.cost > _maxHops) {
        errors.add(
          'Cost ${route.cost} exceeds maximum hops $_maxHops for destination ${route.destination}',
        );
      }
    }

    // Check for circular routes
    for (final route in routingTable.routes.values) {
      if (route.nextHop != null && route.nextHop == routingTable.sourceNode) {
        errors.add(
          'Circular route detected: ${route.destination} -> ${route.nextHop}',
        );
      }
    }

    return errors;
  }
}

/// Convenience function for quick route computation
///
/// [network] - Network topology as adjacency list
/// [sourceNode] - Source node for routing table
/// [maxHops] - Maximum hop count (default: 15)
///
/// Returns complete routing table from source node
///
/// Throws [ArgumentError] if source node doesn't exist in network
RoutingTable<T> computeRIPRoutes<T>(
  Map<T, Map<T, num>> network,
  T sourceNode, {
  int maxHops = 15,
}) {
  return RIPAlgorithm<T>().computeRoutes(network, sourceNode, maxHops: maxHops);
}
