/// 🌍 BGP (Border Gateway Protocol) Algorithm
///
/// Implements the Border Gateway Protocol for inter-domain routing with path
/// vector routing and policy-based decision making. BGP is the de facto
/// standard for routing between autonomous systems (AS) on the Internet.
///
/// - **Time Complexity**: O(V²) for path computation and policy evaluation
/// - **Space Complexity**: O(V²) for routing information base (RIB)
/// - **Convergence**: Slow convergence due to policy complexity
/// - **Path Selection**: Based on multiple attributes and policies
/// - **AS Support**: Full autonomous system number support
///
/// The algorithm maintains a routing information base (RIB) with path
/// attributes, community values, and policy-based route selection.
///
/// Example:
/// ```dart
/// final asTopology = <int, Map<int, num>>{
///   100: {200: 1, 300: 1},
///   200: {100: 1, 400: 1},
///   300: {100: 1, 400: 1},
///   400: {200: 1, 300: 1},
/// };
/// final bgp = BGPAlgorithm<int>();
/// final routes = bgp.computeRoutes(asTopology, 100);
/// // Result: Complete BGP routing table with AS paths
/// ```
library;

/// Represents BGP path attributes for route selection
class BGPPathAttributes {
  final int asPathLength;
  final List<int> asPath;
  final int origin;
  final int localPreference;
  final int med;
  final List<String> communities;
  final bool atomicAggregate;
  final String? aggregator;

  const BGPPathAttributes({
    required this.asPathLength,
    required this.asPath,
    required this.origin,
    this.localPreference = 100,
    this.med = 0,
    this.communities = const [],
    this.atomicAggregate = false,
    this.aggregator,
  });

  /// Creates a copy with updated values
  BGPPathAttributes copyWith({
    int? asPathLength,
    List<int>? asPath,
    int? origin,
    int? localPreference,
    int? med,
    List<String>? communities,
    bool? atomicAggregate,
    String? aggregator,
  }) {
    return BGPPathAttributes(
      asPathLength: asPathLength ?? this.asPathLength,
      asPath: asPath ?? this.asPath,
      origin: origin ?? this.origin,
      localPreference: localPreference ?? this.localPreference,
      med: med ?? this.med,
      communities: communities ?? this.communities,
      atomicAggregate: atomicAggregate ?? this.atomicAggregate,
      aggregator: aggregator ?? this.aggregator,
    );
  }

  /// Adds an AS to the path
  BGPPathAttributes addAS(int asNumber) {
    final newPath = List<int>.from(asPath)..add(asNumber);
    return copyWith(asPath: newPath, asPathLength: newPath.length);
  }

  /// Checks if AS path contains a specific AS number
  bool containsAS(int asNumber) => asPath.contains(asNumber);

  /// Checks if AS path contains loops
  bool hasLoops() {
    final seen = <int>{};
    for (final asNum in asPath) {
      if (seen.contains(asNum)) return true;
      seen.add(asNum);
    }
    return false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BGPPathAttributes &&
          runtimeType == other.runtimeType &&
          asPathLength == other.asPathLength &&
          asPath == other.asPath &&
          origin == other.origin &&
          localPreference == other.localPreference &&
          med == other.med;

  @override
  int get hashCode =>
      Object.hash(asPathLength, asPath, origin, localPreference, med);

  @override
  String toString() =>
      'BGPPathAttributes(path: $asPath, origin: $origin, localPref: $localPreference, med: $med)';
}

/// BGP origin types
enum BGPOrigin {
  igp, // Interior Gateway Protocol
  egp, // Exterior Gateway Protocol
  incomplete, // Unknown origin
}

/// Represents a BGP route with path attributes and policy information
class BGPRouteEntry<T> {
  final T destination;
  final T? nextHop;
  final int asPathLength;
  final List<int> asPath;
  final BGPOrigin origin;
  final int localPreference;
  final int med;
  final List<String> communities;
  final DateTime lastUpdate;
  final bool isDirectlyConnected;
  final int advertisingAS;
  final Map<String, dynamic> additionalAttributes;

  const BGPRouteEntry({
    required this.destination,
    this.nextHop,
    required this.asPathLength,
    required this.asPath,
    required this.origin,
    required this.localPreference,
    required this.med,
    this.communities = const [],
    required this.lastUpdate,
    required this.isDirectlyConnected,
    required this.advertisingAS,
    this.additionalAttributes = const {},
  });

  /// Creates a copy with updated values
  BGPRouteEntry<T> copyWith({
    T? destination,
    T? nextHop,
    int? asPathLength,
    List<int>? asPath,
    BGPOrigin? origin,
    int? localPreference,
    int? med,
    List<String>? communities,
    DateTime? lastUpdate,
    bool? isDirectlyConnected,
    int? advertisingAS,
    Map<String, dynamic>? additionalAttributes,
  }) {
    return BGPRouteEntry<T>(
      destination: destination ?? this.destination,
      nextHop: nextHop ?? this.nextHop,
      asPathLength: asPathLength ?? this.asPathLength,
      asPath: asPath ?? this.asPath,
      origin: origin ?? this.origin,
      localPreference: localPreference ?? this.localPreference,
      med: med ?? this.med,
      communities: communities ?? this.communities,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isDirectlyConnected: isDirectlyConnected ?? this.isDirectlyConnected,
      advertisingAS: advertisingAS ?? this.advertisingAS,
      additionalAttributes: additionalAttributes ?? this.additionalAttributes,
    );
  }

  /// Gets the path attributes object
  BGPPathAttributes get pathAttributes => BGPPathAttributes(
    asPathLength: asPathLength,
    asPath: asPath,
    origin: _originToInt(origin),
    localPreference: localPreference,
    med: med,
    communities: communities,
  );

  /// Converts BGP origin enum to integer
  int _originToInt(BGPOrigin origin) {
    switch (origin) {
      case BGPOrigin.igp:
        return 0;
      case BGPOrigin.egp:
        return 1;
      case BGPOrigin.incomplete:
        return 2;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BGPRouteEntry<T> &&
          runtimeType == other.runtimeType &&
          destination == other.destination &&
          nextHop == other.nextHop &&
          asPathLength == other.asPathLength &&
          asPath == other.asPath;

  @override
  int get hashCode => Object.hash(destination, nextHop, asPathLength, asPath);

  @override
  String toString() =>
      'BGPRoute(dest: $destination, nextHop: $nextHop, asPath: $asPath, origin: $origin)';
}

/// Represents the BGP routing information base (RIB)
class BGPRoutingTable<T> {
  final T sourceAS;
  final Map<T, BGPRouteEntry<T>> routes;
  final Map<T, List<BGPRouteEntry<T>>> alternativeRoutes;
  final DateTime lastUpdate;
  final int totalRoutes;
  final int totalASes;

  const BGPRoutingTable({
    required this.sourceAS,
    required this.routes,
    required this.alternativeRoutes,
    required this.lastUpdate,
    required this.totalRoutes,
    required this.totalASes,
  });

  /// Gets the best route to a specific destination
  BGPRouteEntry<T>? getBestRoute(T destination) => routes[destination];

  /// Gets all alternative routes to a destination
  List<BGPRouteEntry<T>> getAlternativeRoutes(T destination) =>
      alternativeRoutes[destination] ?? [];

  /// Gets all routes as a list
  List<BGPRouteEntry<T>> get allRoutes => routes.values.toList();

  /// Gets the number of routes
  int get routeCount => routes.length;

  /// Gets routes by origin type
  List<BGPRouteEntry<T>> getRoutesByOrigin(BGPOrigin origin) =>
      routes.values.where((route) => route.origin == origin).toList();

  /// Gets routes with specific community
  List<BGPRouteEntry<T>> getRoutesByCommunity(String community) =>
      routes.values
          .where((route) => route.communities.contains(community))
          .toList();

  /// Gets routes with AS path length less than or equal to maxLength
  List<BGPRouteEntry<T>> getRoutesByPathLength(int maxLength) =>
      routes.values.where((route) => route.asPathLength <= maxLength).toList();

  /// Gets directly connected routes
  List<BGPRouteEntry<T>> get directlyConnectedRoutes =>
      routes.values.where((route) => route.isDirectlyConnected).toList();

  @override
  String toString() =>
      'BGPRoutingTable(sourceAS: $sourceAS, routes: $totalRoutes, ases: $totalASes, lastUpdate: $lastUpdate)';
}

/// BGP Algorithm implementation with policy-based route selection
class BGPAlgorithm<T> {
  static const int _maxASPathLength = 255;
  static const Duration _defaultUpdateInterval = Duration(seconds: 30);
  static const Duration _routeTimeout = Duration(seconds: 180);
  static const int _defaultLocalPreference = 100;

  final Duration updateInterval;
  final Duration routeTimeout;
  final int maxIterations;
  final bool enablePolicyBasedSelection;

  /// Creates a BGP algorithm instance with configurable parameters
  ///
  /// [updateInterval] - How often routing tables are updated
  /// [routeTimeout] - How long before routes are considered stale
  /// [maxIterations] - Maximum iterations for convergence
  /// [enablePolicyBasedSelection] - Whether to enable policy-based route selection
  const BGPAlgorithm({
    this.updateInterval = _defaultUpdateInterval,
    this.routeTimeout = _routeTimeout,
    this.maxIterations = 1000,
    this.enablePolicyBasedSelection = true,
  });

  /// Computes complete BGP routing table for a source AS
  ///
  /// [asTopology] - AS topology as adjacency list
  /// [sourceAS] - Source AS for routing table computation
  /// [policies] - Optional routing policies to apply
  ///
  /// Returns a complete BGP routing table with optimal paths
  ///
  /// Throws [ArgumentError] if source AS doesn't exist in topology
  BGPRoutingTable<T> computeRoutes(
    Map<T, Map<T, num>> asTopology,
    T sourceAS, {
    Map<String, dynamic>? policies,
  }) {
    // Input validation
    if (!asTopology.containsKey(sourceAS)) {
      throw ArgumentError('Source AS $sourceAS not found in topology');
    }

    // Initialize routing table with direct connections
    final routes = <T, BGPRouteEntry<T>>{};
    final alternativeRoutes = <T, List<BGPRouteEntry<T>>>{};
    final now = DateTime.now();

    // Add source AS to itself
    routes[sourceAS] = BGPRouteEntry<T>(
      destination: sourceAS,
      nextHop: null,
      asPathLength: 0,
      asPath: <int>[],
      origin: BGPOrigin.igp,
      localPreference: _defaultLocalPreference,
      med: 0,
      lastUpdate: now,
      isDirectlyConnected: true,
      advertisingAS: sourceAS as int,
    );

    // Add directly connected ASes
    final directNeighbors = asTopology[sourceAS]!;
    for (final neighbor in directNeighbors.keys) {
      final route = BGPRouteEntry<T>(
        destination: neighbor,
        nextHop: neighbor,
        asPathLength: 1,
        asPath: <int>[sourceAS as int],
        origin: BGPOrigin.egp,
        localPreference: _defaultLocalPreference,
        med: 0,
        lastUpdate: now,
        isDirectlyConnected: true,
        advertisingAS: neighbor as int,
      );

      routes[neighbor] = route;
      alternativeRoutes[neighbor] = [route];
    }

    // BGP path vector routing computation
    for (int iteration = 0; iteration < maxIterations; iteration++) {
      bool hasChanges = false;

      // Process each AS in the topology
      for (final asNum in asTopology.keys) {
        if (asNum == sourceAS) continue;

        final neighbors = asTopology[asNum]!;
        for (final neighbor in neighbors.keys) {
          // Skip if neighbor is not in our routing table
          if (!routes.containsKey(neighbor)) continue;

          final neighborRoute = routes[neighbor]!;
          final newPathLength = neighborRoute.asPathLength + 1;

          // Check AS path length limit
          if (newPathLength > _maxASPathLength) continue;

          // Create new AS path
          final newAsPath = List<int>.from(neighborRoute.asPath)
            ..add(neighbor as int);

          // Check for AS path loops
          if (_hasASPathLoop(newAsPath)) continue;

          // Check if we found a better route
          if (!routes.containsKey(asNum) ||
              _isBetterRoute(neighborRoute, routes[asNum]!)) {
            final newRoute = BGPRouteEntry<T>(
              destination: asNum,
              nextHop: neighbor,
              asPathLength: newPathLength,
              asPath: newAsPath,
              origin: BGPOrigin.egp,
              localPreference: neighborRoute.localPreference,
              med: neighborRoute.med,
              lastUpdate: now,
              isDirectlyConnected: false,
              advertisingAS: neighbor as int,
            );

            routes[asNum] = newRoute;

            // Add to alternative routes
            alternativeRoutes[asNum] ??= <BGPRouteEntry<T>>[];
            alternativeRoutes[asNum]!.add(newRoute);

            hasChanges = true;
          }
        }
      }

      // If no changes in this iteration, we've converged
      if (!hasChanges) break;
    }

    // Apply policy-based route selection if enabled
    if (enablePolicyBasedSelection && policies != null) {
      _applyRoutingPolicies(routes, alternativeRoutes, policies);
    }

    // Select best routes based on BGP decision process
    final bestRoutes = _selectBestRoutes(routes, alternativeRoutes);

    return BGPRoutingTable<T>(
      sourceAS: sourceAS,
      routes: Map.unmodifiable(bestRoutes),
      alternativeRoutes: Map.unmodifiable(alternativeRoutes),
      lastUpdate: now,
      totalRoutes: bestRoutes.length,
      totalASes: asTopology.length,
    );
  }

  /// Checks if AS path contains loops
  bool _hasASPathLoop(List<int> asPath) {
    final seen = <int>{};
    for (final asNum in asPath) {
      if (seen.contains(asNum)) return true;
      seen.add(asNum);
    }
    return false;
  }

  /// Determines if one route is better than another based on BGP criteria
  bool _isBetterRoute(BGPRouteEntry<T> route1, BGPRouteEntry<T> route2) {
    // BGP route selection criteria (simplified)

    // 1. Highest Local Preference
    if (route1.localPreference != route2.localPreference) {
      return route1.localPreference > route2.localPreference;
    }

    // 2. Shortest AS Path
    if (route1.asPathLength != route2.asPathLength) {
      return route1.asPathLength < route2.asPathLength;
    }

    // 3. Lowest Origin (IGP < EGP < Incomplete)
    if (route1.origin != route2.origin) {
      return _originToInt(route1.origin) < _originToInt(route2.origin);
    }

    // 4. Lowest MED
    if (route1.med != route2.med) {
      return route1.med < route2.med;
    }

    // 5. Prefer directly connected routes
    if (route1.isDirectlyConnected != route2.isDirectlyConnected) {
      return route1.isDirectlyConnected;
    }

    return false;
  }

  /// Converts BGP origin enum to integer for comparison
  int _originToInt(BGPOrigin origin) {
    switch (origin) {
      case BGPOrigin.igp:
        return 0;
      case BGPOrigin.egp:
        return 1;
      case BGPOrigin.incomplete:
        return 2;
    }
  }

  /// Applies routing policies to modify route selection
  void _applyRoutingPolicies(
    Map<T, BGPRouteEntry<T>> routes,
    Map<T, List<BGPRouteEntry<T>>> alternativeRoutes,
    Map<String, dynamic> policies,
  ) {
    // Apply community-based policies
    if (policies.containsKey('communities')) {
      final communityPolicies = policies['communities'] as Map<String, dynamic>;
      for (final route in routes.values) {
        for (final community in route.communities) {
          if (communityPolicies.containsKey(community)) {
            final policy = communityPolicies[community];
            if (policy['action'] == 'prefer') {
              // Modify local preference
              final updatedRoute = route.copyWith(
                localPreference:
                    route.localPreference + (policy['value'] as int? ?? 10),
              );
              routes[route.destination] = updatedRoute;
            }
          }
        }
      }
    }

    // Apply AS path-based policies
    if (policies.containsKey('asPath')) {
      final asPathPolicies = policies['asPath'] as Map<String, dynamic>;
      for (final route in routes.values) {
        for (final asNum in route.asPath) {
          if (asPathPolicies.containsKey(asNum.toString())) {
            final policy = asPathPolicies[asNum.toString()];
            if (policy['action'] == 'penalize') {
              // Increase MED
              final updatedRoute = route.copyWith(
                med: route.med + (policy['value'] as int? ?? 100),
              );
              routes[route.destination] = updatedRoute;
            }
          }
        }
      }
    }
  }

  /// Selects best routes based on BGP decision process
  Map<T, BGPRouteEntry<T>> _selectBestRoutes(
    Map<T, BGPRouteEntry<T>> routes,
    Map<T, List<BGPRouteEntry<T>>> alternativeRoutes,
  ) {
    final bestRoutes = <T, BGPRouteEntry<T>>{};

    for (final entry in routes.entries) {
      final destination = entry.key;
      final route = entry.value;

      // Get all alternative routes for this destination
      final alternatives = alternativeRoutes[destination] ?? [route];

      // Select the best route based on BGP criteria
      BGPRouteEntry<T> bestRoute = alternatives.first;
      for (final altRoute in alternatives.skip(1)) {
        if (_isBetterRoute(altRoute, bestRoute)) {
          bestRoute = altRoute;
        }
      }

      bestRoutes[destination] = bestRoute;
    }

    return bestRoutes;
  }

  /// Updates routing table based on received BGP updates
  ///
  /// [currentTable] - Current routing table
  /// [updates] - BGP route updates from neighbors
  /// [asTopology] - Current AS topology
  ///
  /// Returns updated routing table if changes occurred
  BGPRoutingTable<T>? updateFromBGPUpdate(
    BGPRoutingTable<T> currentTable,
    Map<T, BGPRouteEntry<T>> updates,
    Map<T, Map<T, num>> asTopology,
  ) {
    bool hasChanges = false;
    final updatedRoutes = Map<T, BGPRouteEntry<T>>.from(currentTable.routes);

    for (final entry in updates.entries) {
      final destination = entry.key;
      final updateRoute = entry.value;

      // Check if we have a better route
      if (!updatedRoutes.containsKey(destination) ||
          _isBetterRoute(updateRoute, updatedRoutes[destination]!)) {
        updatedRoutes[destination] = updateRoute;
        hasChanges = true;
      }
    }

    if (!hasChanges) return null;

    // Recompute routing table with new information
    return computeRoutes(asTopology, currentTable.sourceAS);
  }

  /// Gets BGP statistics for monitoring and analysis
  ///
  /// [routingTable] - Routing table to analyze
  ///
  /// Returns map with various statistics
  Map<String, dynamic> getBGPStatistics(BGPRoutingTable<T> routingTable) {
    final routes = routingTable.routes.values;
    final asPaths = routes.map((r) => r.asPathLength).toList();
    final origins = routes.map((r) => r.origin).toList();

    return {
      'totalRoutes': routes.length,
      'directlyConnected': routes.where((r) => r.isDirectlyConnected).length,
      'indirectRoutes': routes.where((r) => !r.isDirectlyConnected).length,
      'averageASPathLength':
          asPaths.isEmpty
              ? 0.0
              : asPaths.reduce((a, b) => a + b) / asPaths.length,
      'maxASPathLength':
          asPaths.isEmpty ? 0 : asPaths.reduce((a, b) => a > b ? a : b),
      'minASPathLength':
          asPaths.isEmpty ? 0 : asPaths.reduce((a, b) => a < b ? a : b),
      'originDistribution': Map.fromEntries(
        BGPOrigin.values.map(
          (origin) => MapEntry(
            origin.toString(),
            origins.where((o) => o == origin).length,
          ),
        ),
      ),
      'communityCount': routes.fold(
        0,
        (sum, route) => sum + route.communities.length,
      ),
      'totalAlternativeRoutes': routingTable.alternativeRoutes.values.fold(
        0,
        (sum, alternatives) => sum + alternatives.length,
      ),
    };
  }

  /// Validates BGP routing table consistency
  ///
  /// [routingTable] - Routing table to validate
  /// [asTopology] - AS topology for validation
  ///
  /// Returns list of validation errors (empty if valid)
  List<String> validateBGPTable(
    BGPRoutingTable<T> routingTable,
    Map<T, Map<T, num>> asTopology,
  ) {
    final errors = <String>[];

    // Check if source AS exists in topology
    if (!asTopology.containsKey(routingTable.sourceAS)) {
      errors.add('Source AS ${routingTable.sourceAS} not found in topology');
    }

    // Check for invalid AS path lengths
    for (final route in routingTable.routes.values) {
      if (route.asPathLength < 0) {
        errors.add(
          'Invalid AS path length ${route.asPathLength} for destination ${route.destination}',
        );
      }
      if (route.asPathLength > _maxASPathLength) {
        errors.add(
          'AS path length ${route.asPathLength} exceeds maximum $_maxASPathLength for destination ${route.destination}',
        );
      }
    }

    // Check for AS path loops
    for (final route in routingTable.routes.values) {
      if (_hasASPathLoop(route.asPath)) {
        errors.add(
          'AS path loop detected for destination ${route.destination}: ${route.asPath}',
        );
      }
    }

    return errors;
  }
}

/// Convenience function for quick BGP route computation
///
/// [asTopology] - AS topology as adjacency list
/// [sourceAS] - Source AS for routing table
/// [policies] - Optional routing policies
///
/// Returns complete BGP routing table from source AS
///
/// Throws [ArgumentError] if source AS doesn't exist in topology
BGPRoutingTable<T> computeBGPRoutes<T>(
  Map<T, Map<T, num>> asTopology,
  T sourceAS, {
  Map<String, dynamic>? policies,
}) {
  return BGPAlgorithm<T>().computeRoutes(
    asTopology,
    sourceAS,
    policies: policies,
  );
}
