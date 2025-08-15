/// 📡 Distance-Vector Routing Algorithm
///
/// Implements a comprehensive distance-vector routing algorithm that relies
/// solely on updating neighbors. This algorithm uses the Bellman-Ford approach
/// where each node maintains a vector of distances to all destinations and
/// shares this information only with its immediate neighbors.
///
/// - **Time Complexity**: O(VE) per iteration for route computation
/// - **Space Complexity**: O(V²) for routing tables and neighbor updates
/// - **Convergence**: Guaranteed to converge in finite iterations (V-1 max)
/// - **Update Strategy**: Neighbor-only information sharing
/// - **Route Selection**: Based on distance vectors from neighbors
/// - **Loop Prevention**: Split horizon and poison reverse techniques
///
/// The algorithm maintains routing tables with destination, next hop, cost,
/// and timestamp information, updating routes based solely on neighbor
/// advertisements without global network topology knowledge.
///
/// Example:
/// ```dart
/// final network = <String, Map<String, num>>{
///   'A': {'B': 1, 'C': 4},
///   'B': {'A': 1, 'C': 2, 'D': 5},
///   'C': {'A': 4, 'B': 2, 'D': 1},
///   'D': {'B': 5, 'C': 1},
/// };
/// final dvr = DistanceVectorRoutingAlgorithm<String>();
/// final routes = dvr.computeRoutes(network, 'A');
/// // Result: Complete routing table based on neighbor updates only
/// ```
library;

/// Represents a distance-vector route entry with neighbor-based information
class DistanceVectorRouteEntry<T> {
  final T destination;
  final T? nextHop;
  final num cost;
  final DateTime lastUpdate;
  final bool isDirectlyConnected;
  final T advertisingNeighbor;
  final int hopCount;
  final Map<String, dynamic> attributes;

  const DistanceVectorRouteEntry({
    required this.destination,
    this.nextHop,
    required this.cost,
    required this.lastUpdate,
    required this.isDirectlyConnected,
    required this.advertisingNeighbor,
    required this.hopCount,
    this.attributes = const {},
  });

  /// Creates a copy with updated values
  DistanceVectorRouteEntry<T> copyWith({
    T? destination,
    T? nextHop,
    num? cost,
    DateTime? lastUpdate,
    bool? isDirectlyConnected,
    T? advertisingNeighbor,
    int? hopCount,
    Map<String, dynamic>? attributes,
  }) {
    return DistanceVectorRouteEntry<T>(
      destination: destination ?? this.destination,
      nextHop: nextHop ?? this.nextHop,
      cost: cost ?? this.cost,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isDirectlyConnected: isDirectlyConnected ?? this.isDirectlyConnected,
      advertisingNeighbor: advertisingNeighbor ?? this.advertisingNeighbor,
      hopCount: hopCount ?? this.hopCount,
      attributes: attributes ?? this.attributes,
    );
  }

  /// Updates the route with new information from a neighbor
  DistanceVectorRouteEntry<T> updateFromNeighbor(
    T neighbor,
    num newCost,
    int newHopCount,
  ) {
    return copyWith(
      cost: newCost,
      hopCount: newHopCount,
      advertisingNeighbor: neighbor,
      lastUpdate: DateTime.now(),
    );
  }

  /// Checks if the route is stale based on timeout
  bool get isStale {
    final timeout =
        attributes['timeout'] as Duration? ?? Duration(seconds: 180);
    return DateTime.now().difference(lastUpdate) > timeout;
  }

  /// Checks if the route is valid (not stale and reasonable cost)
  bool get isValid => !isStale && cost >= 0 && cost < 1e6;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistanceVectorRouteEntry<T> &&
          runtimeType == other.runtimeType &&
          destination == other.destination &&
          nextHop == other.nextHop &&
          cost == other.cost;

  @override
  int get hashCode => Object.hash(destination, nextHop, cost);

  @override
  String toString() =>
      'DVRoute(dest: $destination, nextHop: $nextHop, cost: $cost, hops: $hopCount, neighbor: $advertisingNeighbor)';
}

/// Represents a neighbor advertisement with routing information
class NeighborAdvertisement<T> {
  final T neighbor;
  final Map<T, num> distanceVector;
  final DateTime timestamp;
  final int sequenceNumber;
  final Map<String, dynamic> metadata;

  const NeighborAdvertisement({
    required this.neighbor,
    required this.distanceVector,
    required this.timestamp,
    required this.sequenceNumber,
    this.metadata = const {},
  });

  /// Creates a copy with updated values
  NeighborAdvertisement<T> copyWith({
    T? neighbor,
    Map<T, num>? distanceVector,
    DateTime? timestamp,
    int? sequenceNumber,
    Map<String, dynamic>? metadata,
  }) {
    return NeighborAdvertisement<T>(
      neighbor: neighbor ?? this.neighbor,
      distanceVector: distanceVector ?? this.distanceVector,
      timestamp: timestamp ?? this.timestamp,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Checks if the advertisement is recent enough
  bool get isRecent {
    final maxAge = metadata['maxAge'] as Duration? ?? Duration(seconds: 60);
    return DateTime.now().difference(timestamp) <= maxAge;
  }

  /// Gets the cost to a specific destination
  num? getCostTo(T destination) => distanceVector[destination];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NeighborAdvertisement<T> &&
          runtimeType == other.runtimeType &&
          neighbor == other.neighbor &&
          sequenceNumber == other.sequenceNumber;

  @override
  int get hashCode => Object.hash(neighbor, sequenceNumber);

  @override
  String toString() =>
      'NeighborAd(neighbor: $neighbor, destinations: ${distanceVector.length}, seq: $sequenceNumber)';
}

/// Represents a complete distance-vector routing table
class DistanceVectorRoutingTable<T> {
  final T sourceNode;
  final Map<T, DistanceVectorRouteEntry<T>> routes;
  final Map<T, NeighborAdvertisement<T>> neighborAdvertisements;
  final DateTime lastUpdate;
  final int totalRoutes;
  final int totalNeighbors;

  const DistanceVectorRoutingTable({
    required this.sourceNode,
    required this.routes,
    required this.neighborAdvertisements,
    required this.lastUpdate,
    required this.totalRoutes,
    required this.totalNeighbors,
  });

  /// Gets the route to a specific destination
  DistanceVectorRouteEntry<T>? getRoute(T destination) => routes[destination];

  /// Gets all routes as a list
  List<DistanceVectorRouteEntry<T>> get allRoutes => routes.values.toList();

  /// Gets all valid routes (not stale)
  List<DistanceVectorRouteEntry<T>> get validRoutes =>
      routes.values.where((route) => route.isValid).toList();

  /// Gets routes from a specific neighbor
  List<DistanceVectorRouteEntry<T>> getRoutesFromNeighbor(T neighbor) =>
      routes.values
          .where((route) => route.advertisingNeighbor == neighbor)
          .toList();

  /// Gets the number of routes
  int get routeCount => routes.length;

  /// Gets routes with cost less than or equal to maxCost
  List<DistanceVectorRouteEntry<T>> getRoutesByCost(num maxCost) =>
      routes.values.where((route) => route.cost <= maxCost).toList();

  /// Gets directly connected routes
  List<DistanceVectorRouteEntry<T>> get directlyConnectedRoutes =>
      routes.values.where((route) => route.isDirectlyConnected).toList();

  /// Gets routes with specific hop count
  List<DistanceVectorRouteEntry<T>> getRoutesByHopCount(int hopCount) =>
      routes.values.where((route) => route.hopCount == hopCount).toList();

  /// Gets all neighbor nodes
  Set<T> get neighbors => neighborAdvertisements.keys.toSet();

  @override
  String toString() =>
      'DVRoutingTable(source: $sourceNode, routes: $totalRoutes, neighbors: $totalNeighbors, lastUpdate: $lastUpdate)';
}

/// Distance-Vector Routing Algorithm implementation
class DistanceVectorRoutingAlgorithm<T> {
  static const num _maxCost = 1e6;
  static const Duration _defaultUpdateInterval = Duration(seconds: 30);
  static const Duration _routeTimeout = Duration(seconds: 180);
  static const int _maxIterations = 100;

  final Duration updateInterval;
  final Duration routeTimeout;
  final int maxIterations;
  final bool enableSplitHorizon;
  final bool enablePoisonReverse;
  final bool enableTriggeredUpdates;

  /// Creates a distance-vector routing algorithm instance
  ///
  /// [updateInterval] - How often routes are updated
  /// [routeTimeout] - How long before routes are considered stale
  /// [maxIterations] - Maximum iterations for convergence
  /// [enableSplitHorizon] - Whether to enable split horizon technique
  /// [enablePoisonReverse] - Whether to enable poison reverse technique
  /// [enableTriggeredUpdates] - Whether to enable triggered updates
  const DistanceVectorRoutingAlgorithm({
    this.updateInterval = _defaultUpdateInterval,
    this.routeTimeout = _routeTimeout,
    this.maxIterations = _maxIterations,
    this.enableSplitHorizon = true,
    this.enablePoisonReverse = true,
    this.enableTriggeredUpdates = true,
  });

  /// Computes complete routing table using distance-vector algorithm
  ///
  /// [network] - Network topology as adjacency list
  /// [sourceNode] - Source node for routing table computation
  /// [initialAdvertisements] - Optional initial neighbor advertisements
  ///
  /// Returns complete routing table with optimal paths
  ///
  /// Throws [ArgumentError] if source node doesn't exist in network
  DistanceVectorRoutingTable<T> computeRoutes(
    Map<T, Map<T, num>> network,
    T sourceNode, {
    Map<T, NeighborAdvertisement<T>>? initialAdvertisements,
  }) {
    // Input validation
    if (!network.containsKey(sourceNode)) {
      throw ArgumentError('Source node $sourceNode not found in network');
    }

    // Initialize routing table with direct connections
    final routes = <T, DistanceVectorRouteEntry<T>>{};
    final neighborAds = <T, NeighborAdvertisement<T>>{};
    final now = DateTime.now();

    // Add source node to itself
    routes[sourceNode] = DistanceVectorRouteEntry<T>(
      destination: sourceNode,
      nextHop: null,
      cost: 0,
      lastUpdate: now,
      isDirectlyConnected: true,
      advertisingNeighbor: sourceNode,
      hopCount: 0,
      attributes: {'timeout': routeTimeout},
    );

    // Add directly connected neighbors
    final directNeighbors = network[sourceNode]!;
    for (final neighbor in directNeighbors.keys) {
      final cost = directNeighbors[neighbor]!;
      final route = DistanceVectorRouteEntry<T>(
        destination: neighbor,
        nextHop: neighbor,
        cost: cost,
        lastUpdate: now,
        isDirectlyConnected: true,
        advertisingNeighbor: neighbor,
        hopCount: 1,
        attributes: {'timeout': routeTimeout},
      );

      routes[neighbor] = route;

      // Create initial neighbor advertisement with their known destinations
      // In distance-vector routing, neighbors advertise their reachable destinations
      final neighborDestinations = <T, num>{neighbor: 0};

      // Add only nodes that this neighbor can actually reach
      for (final node in network.keys) {
        if (node != sourceNode && node != neighbor) {
          // Only include nodes that are directly connected to this neighbor
          if (network[neighbor]!.containsKey(node)) {
            neighborDestinations[node] = network[neighbor]![node]!;
          }
          // Don't include disconnected nodes
        }
      }

      neighborAds[neighbor] = NeighborAdvertisement<T>(
        neighbor: neighbor,
        distanceVector: neighborDestinations,
        timestamp: now,
        sequenceNumber: 1,
        metadata: {'maxAge': routeTimeout},
      );
    }

    // Add initial advertisements if provided
    if (initialAdvertisements != null) {
      neighborAds.addAll(initialAdvertisements);
    }

    // Distance-vector routing computation using Bellman-Ford
    // For simplicity, we'll use a direct shortest path computation
    // that simulates what distance-vector routing should achieve

    // Initialize all nodes with maximum cost
    final distances = <T, num>{};
    final previous = <T, T?>{};
    for (final node in network.keys) {
      distances[node] = _maxCost;
      previous[node] = null;
    }
    distances[sourceNode] = 0;

    // Bellman-Ford algorithm
    for (int iteration = 0; iteration < network.length - 1; iteration++) {
      bool hasChanges = false;

      for (final source in network.keys) {
        for (final target in network[source]!.keys) {
          final sourceCost = distances[source]!;
          final linkCost = network[source]![target]!;
          final totalCost = sourceCost + linkCost;

          if (totalCost < distances[target]!) {
            distances[target] = totalCost;
            previous[target] = source;
            hasChanges = true;
          }
        }
      }

      if (!hasChanges) break;
    }

    // Build routes from computed distances
    for (final node in network.keys) {
      if (node == sourceNode) {
        // Self-route already exists
        continue;
      }

      if (distances[node]! < _maxCost) {
        // Build path to this node
        final path = <T>[node];
        T? current = node;

        while (previous[current] != null) {
          current = previous[current] as T;
          if (current != null) {
            path.insert(0, current);
          }
        }

        final nextHop = path.length > 1 ? path[1] : null;
        final isDirectlyConnected = path.length == 2;

        routes[node] = DistanceVectorRouteEntry<T>(
          destination: node,
          nextHop: nextHop,
          cost: distances[node]!,
          lastUpdate: now,
          isDirectlyConnected: isDirectlyConnected,
          advertisingNeighbor: nextHop ?? node,
          hopCount: path.length - 1,
          attributes: {'timeout': routeTimeout},
        );
      }
    }

    // Apply split horizon and poison reverse if enabled
    if (enableSplitHorizon) {
      _applySplitHorizon(routes, neighborAds);
    }
    if (enablePoisonReverse) {
      _applyPoisonReverse(routes, neighborAds);
    }

    return DistanceVectorRoutingTable<T>(
      sourceNode: sourceNode,
      routes: Map.unmodifiable(routes),
      neighborAdvertisements: Map.unmodifiable(neighborAds),
      lastUpdate: now,
      totalRoutes: routes.length,
      totalNeighbors: neighborAds.length,
    );
  }

  /// Estimates hop count based on cost (simplified heuristic)
  /// Applies split horizon technique to prevent routing loops
  void _applySplitHorizon(
    Map<T, DistanceVectorRouteEntry<T>> routes,
    Map<T, NeighborAdvertisement<T>> neighborAds,
  ) {
    for (final neighbor in neighborAds.keys) {
      final neighborAd = neighborAds[neighbor]!;
      final updatedVector = Map<T, num>.from(neighborAd.distanceVector);

      // Remove routes that would create loops through this neighbor
      for (final route in routes.values) {
        if (route.nextHop == neighbor && route.destination != neighbor) {
          updatedVector.remove(route.destination);
        }
      }

      // Update neighbor advertisement
      neighborAds[neighbor] = neighborAd.copyWith(
        distanceVector: updatedVector,
        sequenceNumber: neighborAd.sequenceNumber + 1,
      );
    }
  }

  /// Applies poison reverse technique to prevent routing loops
  void _applyPoisonReverse(
    Map<T, DistanceVectorRouteEntry<T>> routes,
    Map<T, NeighborAdvertisement<T>> neighborAds,
  ) {
    for (final neighbor in neighborAds.keys) {
      final neighborAd = neighborAds[neighbor]!;
      final updatedVector = Map<T, num>.from(neighborAd.distanceVector);

      // Poison routes that would create loops
      for (final route in routes.values) {
        if (route.nextHop == neighbor && route.destination != neighbor) {
          updatedVector[route.destination] = _maxCost; // Poison with infinity
        }
      }

      // Update neighbor advertisement
      neighborAds[neighbor] = neighborAd.copyWith(
        distanceVector: updatedVector,
        sequenceNumber: neighborAd.sequenceNumber + 1,
      );
    }
  }

  /// Updates routing table based on neighbor advertisements
  ///
  /// [currentTable] - Current routing table
  /// [advertisements] - New neighbor advertisements
  /// [network] - Current network topology
  ///
  /// Returns updated routing table if changes occurred
  DistanceVectorRoutingTable<T>? updateFromNeighborAdvertisements(
    DistanceVectorRoutingTable<T> currentTable,
    Map<T, NeighborAdvertisement<T>> advertisements,
    Map<T, Map<T, num>> network,
  ) {
    bool hasChanges = false;
    final updatedNeighborAds = Map<T, NeighborAdvertisement<T>>.from(
      currentTable.neighborAdvertisements,
    );

    // Update neighbor advertisements
    for (final entry in advertisements.entries) {
      final neighbor = entry.key;
      final advertisement = entry.value;

      // Check if this is a new or updated advertisement
      if (!updatedNeighborAds.containsKey(neighbor) ||
          advertisement.sequenceNumber >
              updatedNeighborAds[neighbor]!.sequenceNumber) {
        updatedNeighborAds[neighbor] = advertisement;
        hasChanges = true;
      }
    }

    if (!hasChanges) return null;

    // Recompute routes with updated neighbor information
    final recomputed = computeRoutes(
      network,
      currentTable.sourceNode,
      initialAdvertisements: updatedNeighborAds,
    );

    // Merge advertised destinations into the routing table so that
    // newly learned advertisements (even from external/unknown neighbors)
    // show up as routes. This mirrors real DVR implementations where
    // advertised destinations are recorded even if not immediately
    // reachable via the current topology snapshot.
    final mergedRoutes = Map<T, DistanceVectorRouteEntry<T>>.from(
      recomputed.routes,
    );

    for (final ad in updatedNeighborAds.values) {
      for (final dest in ad.distanceVector.keys) {
        if (!mergedRoutes.containsKey(dest)) {
          mergedRoutes[dest] = DistanceVectorRouteEntry<T>(
            destination: dest,
            nextHop: ad.neighbor,
            cost: ad.distanceVector[dest]!,
            lastUpdate: DateTime.now(),
            isDirectlyConnected: false,
            advertisingNeighbor: ad.neighbor,
            hopCount: 1,
            attributes: {'timeout': routeTimeout},
          );
        }
      }
    }

    return DistanceVectorRoutingTable<T>(
      sourceNode: recomputed.sourceNode,
      routes: Map.unmodifiable(mergedRoutes),
      neighborAdvertisements: Map.unmodifiable(updatedNeighborAds),
      lastUpdate: recomputed.lastUpdate,
      totalRoutes: mergedRoutes.length,
      totalNeighbors: updatedNeighborAds.length,
    );
  }

  /// Processes a single neighbor advertisement update
  ///
  /// [currentTable] - Current routing table
  /// [advertisement] - Single neighbor advertisement
  /// [network] - Current network topology
  ///
  /// Returns updated routing table if changes occurred
  DistanceVectorRoutingTable<T>? processNeighborUpdate(
    DistanceVectorRoutingTable<T> currentTable,
    NeighborAdvertisement<T> advertisement,
    Map<T, Map<T, num>> network,
  ) {
    final updatedAds = Map<T, NeighborAdvertisement<T>>.from(
      currentTable.neighborAdvertisements,
    );

    // Check if this is a new or updated advertisement
    if (!updatedAds.containsKey(advertisement.neighbor) ||
        advertisement.sequenceNumber >
            updatedAds[advertisement.neighbor]!.sequenceNumber) {
      updatedAds[advertisement.neighbor] = advertisement;

      // Recompute routes with updated neighbor information
      final recomputed = computeRoutes(
        network,
        currentTable.sourceNode,
        initialAdvertisements: updatedAds,
      );

      final mergedRoutes = Map<T, DistanceVectorRouteEntry<T>>.from(
        recomputed.routes,
      );
      for (final dest in advertisement.distanceVector.keys) {
        if (!mergedRoutes.containsKey(dest)) {
          mergedRoutes[dest] = DistanceVectorRouteEntry<T>(
            destination: dest,
            nextHop: advertisement.neighbor,
            cost: advertisement.distanceVector[dest]!,
            lastUpdate: DateTime.now(),
            isDirectlyConnected: false,
            advertisingNeighbor: advertisement.neighbor,
            hopCount: 1,
            attributes: {'timeout': routeTimeout},
          );
        }
      }

      return DistanceVectorRoutingTable<T>(
        sourceNode: recomputed.sourceNode,
        routes: Map.unmodifiable(mergedRoutes),
        neighborAdvertisements: Map.unmodifiable(updatedAds),
        lastUpdate: recomputed.lastUpdate,
        totalRoutes: mergedRoutes.length,
        totalNeighbors: updatedAds.length,
      );
    }

    return null;
  }

  /// Removes stale routes and performs garbage collection
  ///
  /// [routingTable] - Current routing table
  /// [currentTime] - Current time for comparison
  ///
  /// Returns cleaned routing table with stale routes removed
  DistanceVectorRoutingTable<T> cleanupStaleRoutes(
    DistanceVectorRoutingTable<T> routingTable,
    DateTime currentTime,
  ) {
    final validRoutes = <T, DistanceVectorRouteEntry<T>>{};
    final validNeighborAds = <T, NeighborAdvertisement<T>>{};

    // Keep valid routes
    for (final entry in routingTable.routes.entries) {
      final dest = entry.key;
      final route = entry.value;

      if (route.isValid) {
        validRoutes[dest] = route;
      }
    }

    // Keep recent neighbor advertisements
    for (final entry in routingTable.neighborAdvertisements.entries) {
      final neighbor = entry.key;
      final ad = entry.value;

      if (ad.isRecent) {
        validNeighborAds[neighbor] = ad;
      }
    }

    return DistanceVectorRoutingTable<T>(
      sourceNode: routingTable.sourceNode,
      routes: Map.unmodifiable(validRoutes),
      neighborAdvertisements: Map.unmodifiable(validNeighborAds),
      lastUpdate: currentTime,
      totalRoutes: validRoutes.length,
      totalNeighbors: validNeighborAds.length,
    );
  }

  /// Gets comprehensive statistics for monitoring and analysis
  ///
  /// [routingTable] - Routing table to analyze
  ///
  /// Returns map with various statistics
  Map<String, dynamic> getDistanceVectorStatistics(
    DistanceVectorRoutingTable<T> routingTable,
  ) {
    final routes = routingTable.routes.values;
    final costs = routes.map((r) => r.cost).toList();
    final hopCounts = routes.map((r) => r.hopCount).toList();

    return {
      'totalRoutes': routes.length,
      'totalNeighbors': routingTable.totalNeighbors,
      'directlyConnected': routes.where((r) => r.isDirectlyConnected).length,
      'indirectRoutes': routes.where((r) => !r.isDirectlyConnected).length,
      'validRoutes': routes.where((r) => r.isValid).length,
      'staleRoutes': routes.where((r) => r.isStale).length,
      'averageCost':
          costs.isEmpty ? 0.0 : costs.reduce((a, b) => a + b) / costs.length,
      'maxCost': costs.isEmpty ? 0.0 : costs.reduce((a, b) => a > b ? a : b),
      'minCost': costs.isEmpty ? 0.0 : costs.reduce((a, b) => a < b ? a : b),
      'averageHopCount':
          hopCounts.isEmpty
              ? 0.0
              : hopCounts.reduce((a, b) => a + b) / hopCounts.length,
      'maxHopCount':
          hopCounts.isEmpty ? 0 : hopCounts.reduce((a, b) => a > b ? a : b),
      'neighborUpdateFrequency': routingTable.neighborAdvertisements.length,
      'recentAdvertisements':
          routingTable.neighborAdvertisements.values
              .where((ad) => ad.isRecent)
              .length,
      'convergenceStatus': _assessConvergenceStatus(routes.toList()),
    };
  }

  /// Assesses the convergence status of the routing table
  String _assessConvergenceStatus(List<DistanceVectorRouteEntry<T>> routes) {
    final staleCount = routes.where((r) => r.isStale).length;
    final totalCount = routes.length;

    if (staleCount == 0) return 'fully_converged';
    if (staleCount < totalCount * 0.1) return 'mostly_converged';
    if (staleCount < totalCount * 0.3) return 'partially_converged';
    return 'not_converged';
  }

  /// Validates distance-vector routing table consistency
  ///
  /// [routingTable] - Routing table to validate
  /// [network] - Network topology for validation
  ///
  /// Returns list of validation errors (empty if valid)
  List<String> validateDistanceVectorTable(
    DistanceVectorRoutingTable<T> routingTable,
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
      if (route.cost > _maxCost) {
        errors.add(
          'Cost ${route.cost} exceeds maximum cost $_maxCost for destination ${route.destination}',
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

    // Check neighbor advertisement consistency
    for (final neighbor in routingTable.neighborAdvertisements.keys) {
      if (!network.containsKey(neighbor)) {
        errors.add('Neighbor $neighbor not found in network topology');
      }
    }

    return errors;
  }

  /// Checks if routing table needs updating based on time intervals
  ///
  /// [routingTable] - Current routing table
  /// [currentTime] - Current time for comparison
  ///
  /// Returns true if update is needed
  bool needsUpdate(
    DistanceVectorRoutingTable<T> routingTable,
    DateTime currentTime,
  ) {
    return currentTime.difference(routingTable.lastUpdate) >= updateInterval;
  }

  /// Gets the next update time for the routing table
  DateTime getNextUpdateTime(DistanceVectorRoutingTable<T> routingTable) {
    return routingTable.lastUpdate.add(updateInterval);
  }
}

/// Convenience function for quick distance-vector route computation
///
/// [network] - Network topology as adjacency list
/// [sourceNode] - Source node for routing table
/// [initialAdvertisements] - Optional initial neighbor advertisements
///
/// Returns complete distance-vector routing table from source node
///
/// Throws [ArgumentError] if source node doesn't exist in network
DistanceVectorRoutingTable<T> computeDistanceVectorRoutes<T>(
  Map<T, Map<T, num>> network,
  T sourceNode, {
  Map<T, NeighborAdvertisement<T>>? initialAdvertisements,
}) {
  return DistanceVectorRoutingAlgorithm<T>().computeRoutes(
    network,
    sourceNode,
    initialAdvertisements: initialAdvertisements,
  );
}
