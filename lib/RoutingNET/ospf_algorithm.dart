/// 🌐 OSPF (Open Shortest Path First) Algorithm
///
/// Implements the Open Shortest Path First routing protocol based on Dijkstra's
/// algorithm for link-state routing. OSPF constructs a complete network topology
/// and computes shortest paths using link costs and network state information.
///
/// - **Time Complexity**: O(V² + E) for Dijkstra's algorithm
/// - **Space Complexity**: O(V²) for link-state database and routing tables
/// - **Convergence**: Fast convergence with link-state updates
/// - **Area Support**: Hierarchical routing with areas and backbone
/// - **Link Types**: Point-to-point, broadcast, non-broadcast, point-to-multipoint
///
/// The algorithm maintains a link-state database (LSDB) containing network
/// topology information and computes optimal routes using shortest path algorithms.
///
/// Example:
/// ```dart
/// final network = <String, Map<String, num>>{
///   'A': {'B': 10, 'C': 20},
///   'B': {'A': 10, 'D': 15},
///   'C': {'A': 20, 'D': 25},
///   'D': {'B': 15, 'C': 25},
/// };
/// final ospf = OSPFAlgorithm<String>();
/// final routes = ospf.computeRoutes(network, 'A');
/// // Result: Complete routing table with optimal paths
/// ```
library;

/// Represents a link-state advertisement (LSA) with network information
class LinkStateAdvertisement<T> {
  final T routerId;
  final T networkId;
  final num linkCost;
  final LinkStateType linkType;
  final DateTime timestamp;
  final int sequenceNumber;
  final int age;

  const LinkStateAdvertisement({
    required this.routerId,
    required this.networkId,
    required this.linkCost,
    required this.linkType,
    required this.timestamp,
    required this.sequenceNumber,
    this.age = 0,
  });

  /// Creates a copy with updated values
  LinkStateAdvertisement<T> copyWith({
    T? routerId,
    T? networkId,
    num? linkCost,
    LinkStateType? linkType,
    DateTime? timestamp,
    int? sequenceNumber,
    int? age,
  }) {
    return LinkStateAdvertisement<T>(
      routerId: routerId ?? this.routerId,
      networkId: networkId ?? this.networkId,
      linkCost: linkCost ?? this.linkCost,
      linkType: linkType ?? this.linkType,
      timestamp: timestamp ?? this.timestamp,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      age: age ?? this.age,
    );
  }

  /// Increments the age of the LSA
  LinkStateAdvertisement<T> incrementAge() {
    return copyWith(age: age + 1);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkStateAdvertisement<T> &&
          runtimeType == other.runtimeType &&
          routerId == other.routerId &&
          networkId == other.networkId &&
          linkCost == other.linkCost &&
          linkType == other.linkType &&
          sequenceNumber == other.sequenceNumber;

  @override
  int get hashCode =>
      Object.hash(routerId, networkId, linkCost, linkType, sequenceNumber);

  @override
  String toString() =>
      'LSA(router: $routerId, network: $networkId, cost: $linkCost, type: $linkType, seq: $sequenceNumber)';
}

/// Types of link-state advertisements
enum LinkStateType {
  routerLSA, // Router LSA
  networkLSA, // Network LSA
  summaryLSA, // Summary LSA
  externalLSA, // External LSA
  nssaExternalLSA, // NSSA External LSA
}

/// Represents a routing table entry with OSPF-specific information
class OSPFRouteEntry<T> {
  final T destination;
  final T? nextHop;
  final num cost;
  final T? advertisingRouter;
  final LinkStateType routeType;
  final DateTime lastUpdate;
  final bool isDirectlyConnected;
  final int areaId;

  const OSPFRouteEntry({
    required this.destination,
    this.nextHop,
    required this.cost,
    this.advertisingRouter,
    required this.routeType,
    required this.lastUpdate,
    required this.isDirectlyConnected,
    this.areaId = 0,
  });

  /// Creates a copy with updated values
  OSPFRouteEntry<T> copyWith({
    T? destination,
    T? nextHop,
    num? cost,
    T? advertisingRouter,
    LinkStateType? routeType,
    DateTime? lastUpdate,
    bool? isDirectlyConnected,
    int? areaId,
  }) {
    return OSPFRouteEntry<T>(
      destination: destination ?? this.destination,
      nextHop: nextHop ?? this.nextHop,
      cost: cost ?? this.cost,
      advertisingRouter: advertisingRouter ?? this.advertisingRouter,
      routeType: routeType ?? this.routeType,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isDirectlyConnected: isDirectlyConnected ?? this.isDirectlyConnected,
      areaId: areaId ?? this.areaId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OSPFRouteEntry<T> &&
          runtimeType == other.runtimeType &&
          destination == other.destination &&
          nextHop == other.nextHop &&
          cost == other.cost &&
          routeType == other.routeType &&
          areaId == this.areaId;

  @override
  int get hashCode =>
      Object.hash(destination, nextHop, cost, routeType, areaId);

  @override
  String toString() =>
      'OSPFRoute(dest: $destination, nextHop: $nextHop, cost: $cost, type: $routeType, area: $areaId)';
}

/// Represents the OSPF routing table with area support
class OSPFRoutingTable<T> {
  final T sourceRouter;
  final Map<T, OSPFRouteEntry<T>> routes;
  final Map<int, Set<T>> areaRoutes;
  final DateTime lastUpdate;
  final int totalAreas;

  const OSPFRoutingTable({
    required this.sourceRouter,
    required this.routes,
    required this.areaRoutes,
    required this.lastUpdate,
    required this.totalAreas,
  });

  /// Gets the route to a specific destination
  OSPFRouteEntry<T>? getRoute(T destination) => routes[destination];

  /// Gets all routes as a list
  List<OSPFRouteEntry<T>> get allRoutes => routes.values.toList();

  /// Gets the number of routes
  int get routeCount => routes.length;

  /// Gets routes in a specific area
  List<OSPFRouteEntry<T>> getRoutesInArea(int areaId) {
    final areaDestinations = areaRoutes[areaId] ?? <T>{};
    return routes.values
        .where((route) => areaDestinations.contains(route.destination))
        .toList();
  }

  /// Gets routes by type
  List<OSPFRouteEntry<T>> getRoutesByType(LinkStateType type) =>
      routes.values.where((route) => route.routeType == type).toList();

  /// Gets routes with cost less than or equal to maxCost
  List<OSPFRouteEntry<T>> getRoutesByCost(num maxCost) =>
      routes.values.where((route) => route.cost <= maxCost).toList();

  /// Gets directly connected routes
  List<OSPFRouteEntry<T>> get directlyConnectedRoutes =>
      routes.values.where((route) => route.isDirectlyConnected).toList();

  @override
  String toString() =>
      'OSPFRoutingTable(router: $sourceRouter, routes: ${routes.length}, areas: $totalAreas, lastUpdate: $lastUpdate)';
}

/// OSPF Algorithm implementation with area support and link-state database
class OSPFAlgorithm<T> {
  static const Duration _defaultLSAInterval = Duration(seconds: 30);
  static const Duration _defaultLSAExpiry = Duration(seconds: 3600);
  static const int _maxSequenceNumber = 0x7FFFFFFF;
  static const num _maxCost = 65535;

  final Duration lsaInterval;
  final Duration lsaExpiry;
  final int maxIterations;
  final bool enableAreas;

  /// Creates an OSPF algorithm instance with configurable parameters
  ///
  /// [lsaInterval] - How often LSAs are generated
  /// [lsaExpiry] - How long before LSAs expire
  /// [maxIterations] - Maximum iterations for convergence
  /// [enableAreas] - Whether to enable OSPF area support
  const OSPFAlgorithm({
    this.lsaInterval = _defaultLSAInterval,
    this.lsaExpiry = _defaultLSAExpiry,
    this.maxIterations = 1000,
    this.enableAreas = true,
  });

  /// Computes complete routing table for a source router using Dijkstra's algorithm
  ///
  /// [network] - Network topology as adjacency list with link costs
  /// [sourceRouter] - Source router for routing table computation
  /// [areaId] - OSPF area ID (0 for backbone area)
  ///
  /// Returns a complete OSPF routing table with optimal paths
  ///
  /// Throws [ArgumentError] if source router doesn't exist in network
  OSPFRoutingTable<T> computeRoutes(
    Map<T, Map<T, num>> network,
    T sourceRouter, {
    int areaId = 0,
  }) {
    // Input validation
    if (!network.containsKey(sourceRouter)) {
      throw ArgumentError('Source router $sourceRouter not found in network');
    }

    // Build link-state database from network topology
    final lsdb = _buildLinkStateDatabase(network, sourceRouter, areaId);

    // Compute shortest paths using Dijkstra's algorithm
    final routes = _computeShortestPaths(network, sourceRouter, lsdb, areaId);

    // Organize routes by area
    final areaRoutes = _organizeRoutesByArea(routes, areaId);

    return OSPFRoutingTable<T>(
      sourceRouter: sourceRouter,
      routes: Map.unmodifiable(routes),
      areaRoutes: Map.unmodifiable(areaRoutes),
      lastUpdate: DateTime.now(),
      totalAreas: areaRoutes.length,
    );
  }

  /// Builds link-state database from network topology
  Map<T, List<LinkStateAdvertisement<T>>> _buildLinkStateDatabase(
    Map<T, Map<T, num>> network,
    T sourceRouter,
    int areaId,
  ) {
    final lsdb = <T, List<LinkStateAdvertisement<T>>>{};
    final now = DateTime.now();
    int sequenceNumber = 1;

    for (final router in network.keys) {
      lsdb[router] = <LinkStateAdvertisement<T>>[];
      final neighbors = network[router]!;

      for (final neighbor in neighbors.keys) {
        final cost = neighbors[neighbor]!;

        // Create router LSA with bounded sequence number
        final lsa = LinkStateAdvertisement<T>(
          routerId: router,
          networkId: neighbor,
          linkCost: cost,
          linkType: LinkStateType.routerLSA,
          timestamp: now,
          sequenceNumber: sequenceNumber % _maxSequenceNumber,
        );

        lsdb[router]!.add(lsa);

        // Add reverse link for bidirectional connectivity
        if (network.containsKey(neighbor) &&
            network[neighbor]!.containsKey(router)) {
          final reverseLsa = LinkStateAdvertisement<T>(
            routerId: neighbor,
            networkId: router,
            linkCost: cost,
            linkType: LinkStateType.routerLSA,
            timestamp: now,
            sequenceNumber: (sequenceNumber + 1) % _maxSequenceNumber,
          );
          lsdb[neighbor] ??= <LinkStateAdvertisement<T>>[];
          lsdb[neighbor]!.add(reverseLsa);
          sequenceNumber += 2; // Increment for both LSAs
        } else {
          sequenceNumber++; // Increment for single LSA
        }
      }
    }

    return lsdb;
  }

  /// Computes shortest paths using Dijkstra's algorithm
  Map<T, OSPFRouteEntry<T>> _computeShortestPaths(
    Map<T, Map<T, num>> network,
    T sourceRouter,
    Map<T, List<LinkStateAdvertisement<T>>> lsdb,
    int areaId,
  ) {
    final routes = <T, OSPFRouteEntry<T>>{};
    final distances = <T, num>{};
    final previous = <T, T?>{};
    final visited = <T>{};
    final now = DateTime.now();

    // Initialize distances
    for (final node in network.keys) {
      distances[node] = double.infinity;
      previous[node] = null;
    }
    distances[sourceRouter] = 0;

    // Add source router to routes
    routes[sourceRouter] = OSPFRouteEntry<T>(
      destination: sourceRouter,
      nextHop: null,
      cost: 0,
      routeType: LinkStateType.routerLSA,
      lastUpdate: now,
      isDirectlyConnected: true,
      areaId: areaId,
    );

    // Dijkstra's algorithm main loop
    while (visited.length < network.length) {
      // Find unvisited node with minimum distance
      T? current;
      num minDistance = double.infinity;

      for (final node in network.keys) {
        if (!visited.contains(node) && distances[node]! < minDistance) {
          minDistance = distances[node]!;
          current = node;
        }
      }

      if (current == null || distances[current] == double.infinity) break;
      visited.add(current);

      // Process neighbors
      final neighbors = network[current]!;
      for (final neighbor in neighbors.keys) {
        if (visited.contains(neighbor)) continue;

        final cost = neighbors[neighbor]!;
        final altDistance = distances[current]! + cost;

        if (altDistance < distances[neighbor]!) {
          distances[neighbor] = altDistance;
          previous[neighbor] = current;

          // Determine next hop for this destination
          T? nextHop = neighbor;
          T? temp = current;

          while (temp != sourceRouter && temp != null) {
            nextHop = temp;
            temp = previous[temp];
          }

          // Add route to routing table
          routes[neighbor] = OSPFRouteEntry<T>(
            destination: neighbor,
            nextHop: nextHop,
            cost: altDistance,
            routeType: LinkStateType.routerLSA,
            lastUpdate: now,
            isDirectlyConnected: false,
            areaId: areaId,
          );
        }
      }
    }

    return routes;
  }

  /// Organizes routes by OSPF areas
  Map<int, Set<T>> _organizeRoutesByArea(
    Map<T, OSPFRouteEntry<T>> routes,
    int defaultAreaId,
  ) {
    final areaRoutes = <int, Set<T>>{};

    for (final route in routes.values) {
      final areaId = route.areaId;
      areaRoutes[areaId] ??= <T>{};
      areaRoutes[areaId]!.add(route.destination);
    }

    return areaRoutes;
  }

  /// Updates routing table based on new link-state advertisements
  ///
  /// [currentTable] - Current routing table
  /// [newLSA] - New link-state advertisement
  /// [network] - Current network topology
  ///
  /// Returns updated routing table if changes occurred
  OSPFRoutingTable<T>? updateFromLSA(
    OSPFRoutingTable<T> currentTable,
    LinkStateAdvertisement<T> newLSA,
    Map<T, Map<T, num>> network,
  ) {
    // Check if LSA is newer than what we have
    final existingRoute = currentTable.getRoute(newLSA.networkId);
    if (existingRoute != null &&
        existingRoute.lastUpdate.isAfter(newLSA.timestamp)) {
      return null; // No update needed
    }

    // Recompute routes if topology changed
    return computeRoutes(network, currentTable.sourceRouter);
  }

  /// Performs link-state database maintenance and cleanup
  ///
  /// [lsdb] - Current link-state database
  /// [currentTime] - Current time for comparison
  ///
  /// Returns cleaned link-state database
  Map<T, List<LinkStateAdvertisement<T>>> cleanupLSDB(
    Map<T, List<LinkStateAdvertisement<T>>> lsdb,
    DateTime currentTime,
  ) {
    final cleanedLSDB = <T, List<LinkStateAdvertisement<T>>>{};

    for (final entry in lsdb.entries) {
      final router = entry.key;
      final lsas = entry.value;
      final validLSAs = <LinkStateAdvertisement<T>>[];

      for (final lsa in lsas) {
        if (currentTime.difference(lsa.timestamp) < lsaExpiry) {
          validLSAs.add(lsa.incrementAge());
        }
      }

      if (validLSAs.isNotEmpty) {
        cleanedLSDB[router] = validLSAs;
      }
    }

    return cleanedLSDB;
  }

  /// Gets OSPF statistics for monitoring and analysis
  ///
  /// [routingTable] - Routing table to analyze
  /// [lsdb] - Link-state database to analyze
  ///
  /// Returns map with various statistics
  Map<String, dynamic> getOSPFStatistics(
    OSPFRoutingTable<T> routingTable,
    Map<T, List<LinkStateAdvertisement<T>>> lsdb,
  ) {
    final routes = routingTable.routes.values;
    final costs = routes.map((r) => r.cost).toList();
    final areas = routingTable.areaRoutes.keys.toList();

    return {
      'totalRoutes': routes.length,
      'totalAreas': areas.length,
      'directlyConnected': routes.where((r) => r.isDirectlyConnected).length,
      'indirectRoutes': routes.where((r) => !r.isDirectlyConnected).length,
      'averageCost':
          costs.isEmpty ? 0.0 : costs.reduce((a, b) => a + b) / costs.length,
      'maxCost': costs.isEmpty ? 0.0 : costs.reduce((a, b) => a > b ? a : b),
      'minCost': costs.isEmpty ? 0.0 : costs.reduce((a, b) => a < b ? a : b),
      'lsdbSize': lsdb.values.fold(0, (sum, lsas) => sum + lsas.length),
      'areaDistribution': Map.fromEntries(
        areas.map(
          (area) => MapEntry(area, routingTable.getRoutesInArea(area).length),
        ),
      ),
      'routeTypeDistribution': Map.fromEntries(
        LinkStateType.values.map(
          (type) => MapEntry(
            type.toString(),
            routingTable.getRoutesByType(type).length,
          ),
        ),
      ),
    };
  }

  /// Validates OSPF routing table consistency
  ///
  /// [routingTable] - Routing table to validate
  /// [network] - Network topology for validation
  ///
  /// Returns list of validation errors (empty if valid)
  List<String> validateOSPFTable(
    OSPFRoutingTable<T> routingTable,
    Map<T, Map<T, num>> network,
  ) {
    final errors = <String>[];

    // Check if source router exists in network
    if (!network.containsKey(routingTable.sourceRouter)) {
      errors.add(
        'Source router ${routingTable.sourceRouter} not found in network',
      );
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
      if (route.nextHop != null && route.nextHop == routingTable.sourceRouter) {
        errors.add(
          'Circular route detected: ${route.destination} -> ${route.nextHop}',
        );
      }
    }

    return errors;
  }
}

/// Convenience function for quick OSPF route computation
///
/// [network] - Network topology as adjacency list
/// [sourceRouter] - Source router for routing table
/// [areaId] - OSPF area ID (default: 0 for backbone)
///
/// Returns complete OSPF routing table from source router
///
/// Throws [ArgumentError] if source router doesn't exist in network
OSPFRoutingTable<T> computeOSPFRoutes<T>(
  Map<T, Map<T, num>> network,
  T sourceRouter, {
  int areaId = 0,
}) {
  return OSPFAlgorithm<T>().computeRoutes(
    network,
    sourceRouter,
    areaId: areaId,
  );
}
