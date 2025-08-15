/// 🗺️ Link-State Routing Algorithm
///
/// Implements a comprehensive link-state routing algorithm that constructs a
/// complete map of the network topology. This algorithm maintains a full
/// network view and computes optimal routes using shortest path algorithms.
///
/// - **Time Complexity**: O(V² + E) for topology construction and route computation
/// - **Space Complexity**: O(V²) for link-state database and routing tables
/// - **Convergence**: Fast convergence with immediate topology updates
/// - **Network View**: Complete network topology visibility
/// - **Route Computation**: Uses Dijkstra's algorithm for optimal paths
/// - **Topology Changes**: Immediate propagation of network changes
///
/// The algorithm maintains a comprehensive link-state database (LSDB) containing
/// complete network topology information and computes optimal routes using
/// shortest path algorithms with full network visibility.
///
/// Example:
/// ```dart
/// final network = <String, Map<String, num>>{
///   'A': {'B': 10, 'C': 20, 'D': 15},
///   'B': {'A': 10, 'C': 5, 'E': 12},
///   'C': {'A': 20, 'B': 5, 'D': 8, 'E': 7},
///   'D': {'A': 15, 'C': 8, 'F': 9},
///   'E': {'B': 12, 'C': 7, 'F': 11},
///   'F': {'D': 9, 'E': 11},
/// };
/// final lsr = LinkStateRoutingAlgorithm<String>();
/// final routes = lsr.computeRoutes(network, 'A');
/// // Result: Complete routing table with optimal paths from full topology
/// ```
library;

/// Represents a link-state entry with complete network information
class LinkStateEntry<T> {
  static const int _maxSequenceNumber = 0x7FFFFFFF;

  final T sourceNode;
  final T targetNode;
  final num linkCost;
  final LinkStateStatus status;
  final DateTime lastUpdate;
  final int sequenceNumber;
  final Map<String, dynamic> attributes;

  const LinkStateEntry({
    required this.sourceNode,
    required this.targetNode,
    required this.linkCost,
    required this.status,
    required this.lastUpdate,
    required this.sequenceNumber,
    this.attributes = const {},
  }) : assert(
         sequenceNumber >= 0 && sequenceNumber <= _maxSequenceNumber,
         'Sequence number must be between 0 and $_maxSequenceNumber',
       );

  /// Creates a copy with updated values
  LinkStateEntry<T> copyWith({
    T? sourceNode,
    T? targetNode,
    num? linkCost,
    LinkStateStatus? status,
    DateTime? lastUpdate,
    int? sequenceNumber,
    Map<String, dynamic>? attributes,
  }) {
    return LinkStateEntry<T>(
      sourceNode: sourceNode ?? this.sourceNode,
      targetNode: targetNode ?? this.targetNode,
      linkCost: linkCost ?? this.linkCost,
      status: status ?? this.status,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      attributes: attributes ?? this.attributes,
    );
  }

  /// Updates the link status and timestamp
  LinkStateEntry<T> updateStatus(LinkStateStatus newStatus) {
    // Ensure sequence number doesn't exceed maximum value
    final newSequenceNumber =
        sequenceNumber >= _maxSequenceNumber ? 1 : sequenceNumber + 1;
    return copyWith(
      status: newStatus,
      lastUpdate: DateTime.now(),
      sequenceNumber: newSequenceNumber,
    );
  }

  /// Checks if the link is active and usable
  bool get isActive => status == LinkStateStatus.active;

  /// Checks if the link is bidirectional
  bool get isBidirectional => attributes['bidirectional'] == true;

  /// Gets the maximum allowed sequence number
  static int get maxSequenceNumber => _maxSequenceNumber;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkStateEntry<T> &&
          runtimeType == other.runtimeType &&
          sourceNode == other.sourceNode &&
          targetNode == other.targetNode &&
          sequenceNumber == other.sequenceNumber;

  @override
  int get hashCode => Object.hash(sourceNode, targetNode, sequenceNumber);

  @override
  String toString() =>
      'LinkStateEntry($sourceNode -> $targetNode, cost: $linkCost, status: $status, seq: $sequenceNumber)';
}

/// Link state status enumeration
enum LinkStateStatus {
  active, // Link is active and usable
  inactive, // Link is inactive
  failed, // Link has failed
  pending, // Link is pending activation
  maintenance, // Link is under maintenance
}

/// Represents a complete link-state database for the network
class LinkStateDatabase<T> {
  final Map<T, List<LinkStateEntry<T>>> nodeLinks;
  final DateTime lastUpdate;
  final int totalLinks;
  final int totalNodes;

  const LinkStateDatabase({
    required this.nodeLinks,
    required this.lastUpdate,
    required this.totalLinks,
    required this.totalNodes,
  });

  /// Gets all links for a specific node
  List<LinkStateEntry<T>> getLinksForNode(T node) => nodeLinks[node] ?? [];

  /// Gets all active links in the database
  List<LinkStateEntry<T>> get activeLinks {
    final active = <LinkStateEntry<T>>[];
    for (final links in nodeLinks.values) {
      active.addAll(links.where((link) => link.isActive));
    }
    return active;
  }

  /// Gets all failed links in the database
  List<LinkStateEntry<T>> get failedLinks {
    final failed = <LinkStateEntry<T>>[];
    for (final links in nodeLinks.values) {
      failed.addAll(
        links.where((link) => link.status == LinkStateStatus.failed),
      );
    }
    return failed;
  }

  /// Gets the total number of active links
  int get activeLinkCount => activeLinks.length;

  /// Gets the total number of failed links
  int get failedLinkCount => failedLinks.length;

  /// Checks if a specific link exists between two nodes
  bool hasLink(T source, T target) {
    final links = nodeLinks[source] ?? [];
    return links.any((link) => link.targetNode == target && link.isActive);
  }

  /// Gets the cost of a link between two nodes
  num? getLinkCost(T source, T target) {
    final links = nodeLinks[source] ?? [];
    for (final link in links) {
      if (link.targetNode == target && link.isActive) {
        return link.linkCost;
      }
    }
    return null;
  }

  @override
  String toString() =>
      'LinkStateDatabase(nodes: $totalNodes, links: $totalLinks, lastUpdate: $lastUpdate)';
}

/// Represents a routing table entry with complete path information
class LinkStateRouteEntry<T> {
  final T destination;
  final T? nextHop;
  final num cost;
  final List<T> path;
  final DateTime lastUpdate;
  final bool isDirectlyConnected;
  final LinkStateStatus linkStatus;

  const LinkStateRouteEntry({
    required this.destination,
    this.nextHop,
    required this.cost,
    required this.path,
    required this.lastUpdate,
    required this.isDirectlyConnected,
    required this.linkStatus,
  });

  /// Creates a copy with updated values
  LinkStateRouteEntry<T> copyWith({
    T? destination,
    T? nextHop,
    num? cost,
    List<T>? path,
    DateTime? lastUpdate,
    bool? isDirectlyConnected,
    LinkStateStatus? linkStatus,
  }) {
    return LinkStateRouteEntry<T>(
      destination: destination ?? this.destination,
      nextHop: nextHop ?? this.nextHop,
      cost: cost ?? this.cost,
      path: path ?? this.path,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isDirectlyConnected: isDirectlyConnected ?? this.isDirectlyConnected,
      linkStatus: linkStatus ?? this.linkStatus,
    );
  }

  /// Gets the hop count (path length - 1)
  int get hopCount => path.length - 1;

  /// Checks if the route is active
  bool get isActive => linkStatus == LinkStateStatus.active;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkStateRouteEntry<T> &&
          runtimeType == other.runtimeType &&
          destination == other.destination &&
          nextHop == other.nextHop &&
          cost == other.cost;

  @override
  int get hashCode => Object.hash(destination, nextHop, cost);

  @override
  String toString() =>
      'LinkStateRoute(dest: $destination, nextHop: $nextHop, cost: $cost, path: $path)';
}

/// Represents a complete link-state routing table
class LinkStateRoutingTable<T> {
  final T sourceNode;
  final Map<T, LinkStateRouteEntry<T>> routes;
  final LinkStateDatabase<T> topology;
  final DateTime lastUpdate;
  final int totalRoutes;
  final int totalNodes;

  const LinkStateRoutingTable({
    required this.sourceNode,
    required this.routes,
    required this.topology,
    required this.lastUpdate,
    required this.totalRoutes,
    required this.totalNodes,
  });

  /// Gets the route to a specific destination
  LinkStateRouteEntry<T>? getRoute(T destination) => routes[destination];

  /// Gets all routes as a list
  List<LinkStateRouteEntry<T>> get allRoutes => routes.values.toList();

  /// Gets all active routes
  List<LinkStateRouteEntry<T>> get activeRoutes =>
      routes.values.where((route) => route.isActive).toList();

  /// Gets the number of routes
  int get routeCount => routes.length;

  /// Gets routes with cost less than or equal to maxCost
  List<LinkStateRouteEntry<T>> getRoutesByCost(num maxCost) =>
      routes.values.where((route) => route.cost <= maxCost).toList();

  /// Gets directly connected routes
  List<LinkStateRouteEntry<T>> get directlyConnectedRoutes =>
      routes.values.where((route) => route.isDirectlyConnected).toList();

  /// Gets routes with specific hop count
  List<LinkStateRouteEntry<T>> getRoutesByHopCount(int hopCount) =>
      routes.values.where((route) => route.hopCount == hopCount).toList();

  @override
  String toString() =>
      'LinkStateRoutingTable(source: $sourceNode, routes: $totalRoutes, nodes: $totalNodes, lastUpdate: $lastUpdate)';
}

/// Link-State Routing Algorithm implementation
class LinkStateRoutingAlgorithm<T> {
  static const num _maxCost = 1e6;
  static const Duration _defaultUpdateInterval = Duration(seconds: 10);
  static const Duration _linkTimeout = Duration(seconds: 60);

  final Duration updateInterval;
  final Duration linkTimeout;
  final bool enableTopologyOptimization;
  final bool enablePathCompression;

  /// Creates a link-state routing algorithm instance
  ///
  /// [updateInterval] - How often topology is updated
  /// [linkTimeout] - How long before links are considered stale
  /// [enableTopologyOptimization] - Whether to optimize topology
  /// [enablePathCompression] - Whether to compress paths for efficiency
  const LinkStateRoutingAlgorithm({
    this.updateInterval = _defaultUpdateInterval,
    this.linkTimeout = _linkTimeout,
    this.enableTopologyOptimization = true,
    this.enablePathCompression = true,
  });

  /// Computes complete routing table using link-state algorithm
  ///
  /// [network] - Network topology as adjacency list
  /// [sourceNode] - Source node for routing table computation
  /// [topologyOptimizations] - Optional topology optimization parameters
  ///
  /// Returns complete routing table with optimal paths
  ///
  /// Throws [ArgumentError] if source node doesn't exist in network
  LinkStateRoutingTable<T> computeRoutes(
    Map<T, Map<T, num>> network,
    T sourceNode, {
    Map<String, dynamic>? topologyOptimizations,
  }) {
    // Input validation
    if (!network.containsKey(sourceNode)) {
      throw ArgumentError('Source node $sourceNode not found in network');
    }

    // Apply topology optimizations to network if enabled
    Map<T, Map<T, num>> optimizedNetwork = network;
    if (enableTopologyOptimization && topologyOptimizations != null) {
      optimizedNetwork = _applyTopologyOptimizationsToNetwork(
        network,
        topologyOptimizations,
      );
    }

    // Build complete link-state database
    final lsdb = _buildLinkStateDatabase(optimizedNetwork);

    // Compute optimal routes using Dijkstra's algorithm
    final routes = _computeOptimalRoutes(lsdb, sourceNode);

    // Compress paths if enabled
    if (enablePathCompression) {
      _compressPaths(routes);
    }

    return LinkStateRoutingTable<T>(
      sourceNode: sourceNode,
      routes: Map.unmodifiable(routes),
      topology: lsdb,
      lastUpdate: DateTime.now(),
      totalRoutes: routes.length,
      totalNodes: network.length,
    );
  }

  /// Applies topology optimizations to the network before building LSDB
  Map<T, Map<T, num>> _applyTopologyOptimizationsToNetwork(
    Map<T, Map<T, num>> network,
    Map<String, dynamic> optimizations,
  ) {
    final optimizedNetwork = <T, Map<T, num>>{};

    // Apply link cost optimizations
    if (optimizations.containsKey('linkCostMultiplier')) {
      final multiplier = optimizations['linkCostMultiplier'] as num;
      for (final entry in network.entries) {
        final source = entry.key;
        final neighbors = entry.value;
        optimizedNetwork[source] = <T, num>{};

        for (final neighborEntry in neighbors.entries) {
          final target = neighborEntry.key;
          final cost = neighborEntry.value;
          optimizedNetwork[source]![target] = cost * multiplier;
        }
      }
    } else {
      // Copy network without modifications
      for (final entry in network.entries) {
        optimizedNetwork[entry.key] = Map<T, num>.from(entry.value);
      }
    }

    // Apply link status optimizations (disable specific links)
    if (optimizations.containsKey('disableLinks')) {
      final disabledLinks = optimizations['disableLinks'] as List<T>;
      for (final disabledNode in disabledLinks) {
        for (final neighbors in optimizedNetwork.values) {
          neighbors.remove(disabledNode);
        }
        // Remove the disabled node entirely
        optimizedNetwork.remove(disabledNode);
      }
    }

    return optimizedNetwork;
  }

  /// Builds complete link-state database from network topology
  LinkStateDatabase<T> _buildLinkStateDatabase(Map<T, Map<T, num>> network) {
    final nodeLinks = <T, List<LinkStateEntry<T>>>{};
    final now = DateTime.now();
    int linkCount = 0;

    // Initialize all nodes
    for (final node in network.keys) {
      nodeLinks[node] = [];
    }

    // Build bidirectional links
    for (final entry in network.entries) {
      final source = entry.key;
      final neighbors = entry.value;

      for (final neighborEntry in neighbors.entries) {
        final target = neighborEntry.key;
        final cost = neighborEntry.value;

        // Create forward link
        final forwardLink = LinkStateEntry<T>(
          sourceNode: source,
          targetNode: target,
          linkCost: cost,
          status: LinkStateStatus.active,
          lastUpdate: now,
          sequenceNumber: 1,
          attributes: {'bidirectional': true},
        );

        // Create reverse link
        final reverseLink = LinkStateEntry<T>(
          sourceNode: target,
          targetNode: source,
          linkCost: cost,
          status: LinkStateStatus.active,
          lastUpdate: now,
          sequenceNumber: 1,
          attributes: {'bidirectional': true},
        );

        nodeLinks[source]!.add(forwardLink);
        nodeLinks[target]!.add(reverseLink);
        linkCount += 2;
      }
    }

    return LinkStateDatabase<T>(
      nodeLinks: nodeLinks,
      lastUpdate: now,
      totalLinks: linkCount,
      totalNodes: network.length,
    );
  }

  /// Computes optimal routes using Dijkstra's algorithm
  Map<T, LinkStateRouteEntry<T>> _computeOptimalRoutes(
    LinkStateDatabase<T> lsdb,
    T sourceNode,
  ) {
    final routes = <T, LinkStateRouteEntry<T>>{};
    final distances = <T, num>{};
    final previous = <T, T?>{};
    final unvisited = <T>{};
    final now = DateTime.now();

    // Initialize distances and unvisited set
    for (final node in lsdb.nodeLinks.keys) {
      distances[node] = _maxCost;
      previous[node] = null;
      unvisited.add(node);
    }
    distances[sourceNode] = 0;

    // Dijkstra's algorithm
    while (unvisited.isNotEmpty) {
      // Find unvisited node with minimum distance
      T? current;
      num minDistance = _maxCost;

      for (final node in unvisited) {
        if (distances[node]! < minDistance) {
          minDistance = distances[node]!;
          current = node;
        }
      }

      if (current == null || distances[current] == _maxCost) break;

      unvisited.remove(current);

      // Update distances to neighbors
      final links = lsdb.getLinksForNode(current);
      for (final link in links) {
        if (!link.isActive) continue;

        final neighbor = link.targetNode;
        if (!unvisited.contains(neighbor)) continue;

        final altDistance = distances[current]! + link.linkCost;
        if (altDistance < distances[neighbor]!) {
          distances[neighbor] = altDistance;
          previous[neighbor] = current;
        }
      }
    }

    // Build routes from computed paths
    for (final node in lsdb.nodeLinks.keys) {
      if (node == sourceNode) {
        // Self-route
        routes[node] = LinkStateRouteEntry<T>(
          destination: node,
          nextHop: null,
          cost: 0,
          path: [node],
          lastUpdate: now,
          isDirectlyConnected: true,
          linkStatus: LinkStateStatus.active,
        );
      } else if (distances[node]! < _maxCost) {
        // Build path to this node
        final path = _buildPath(previous, node);
        final nextHop = path.length > 1 ? path[1] : null;
        final isDirectlyConnected = path.length == 2;

        routes[node] = LinkStateRouteEntry<T>(
          destination: node,
          nextHop: nextHop,
          cost: distances[node]!,
          path: path,
          lastUpdate: now,
          isDirectlyConnected: isDirectlyConnected,
          linkStatus: LinkStateStatus.active,
        );
      }
    }

    return routes;
  }

  /// Builds path from source to target using previous node mapping
  List<T> _buildPath(Map<T, T?> previous, T target) {
    final path = <T>[target];
    T? current = target;

    while (previous[current] != null) {
      current = previous[current] as T;
      if (current != null) {
        path.insert(0, current);
      }
    }

    return path;
  }

  /// Compresses paths for efficiency by removing unnecessary intermediate nodes
  void _compressPaths(Map<T, LinkStateRouteEntry<T>> routes) {
    for (final route in routes.values) {
      if (route.path.length <= 3) continue; // Skip short paths

      final compressedPath = <T>[route.path.first];
      for (int i = 1; i < route.path.length - 1; i++) {
        final node = route.path[i];
        // Keep node if it's a critical junction or has high degree
        if (_isCriticalJunction(node, routes)) {
          compressedPath.add(node);
        }
      }
      compressedPath.add(route.path.last);

      if (compressedPath.length < route.path.length) {
        final compressedRoute = route.copyWith(
          path: compressedPath,
          nextHop: compressedPath.length > 1 ? compressedPath[1] : null,
        );
        routes[route.destination] = compressedRoute;
      }
    }
  }

  /// Determines if a node is a critical junction in the network
  bool _isCriticalJunction(T node, Map<T, LinkStateRouteEntry<T>> routes) {
    // Count how many routes pass through this node
    int routeCount = 0;
    for (final route in routes.values) {
      if (route.path.contains(node)) {
        routeCount++;
      }
    }
    return routeCount >
        2; // Consider critical if more than 2 routes pass through
  }

  /// Updates routing table based on topology changes
  ///
  /// [currentTable] - Current routing table
  /// [topologyChanges] - Changes in network topology
  /// [network] - Current network topology
  ///
  /// Returns updated routing table if changes occurred
  LinkStateRoutingTable<T>? updateFromTopologyChanges(
    LinkStateRoutingTable<T> currentTable,
    List<LinkStateEntry<T>> topologyChanges,
    Map<T, Map<T, num>> network,
  ) {
    // Check if any of the topology changes are significant using the helper method
    final tempNodeLinks = <T, List<LinkStateEntry<T>>>{};
    for (var entry in topologyChanges) {
      tempNodeLinks[entry.sourceNode] = [entry];
    }

    if (!_hasSignificantChanges(
      currentTable.topology,
      LinkStateDatabase<T>(
        nodeLinks: tempNodeLinks,
        lastUpdate: DateTime.now(),
        totalLinks: topologyChanges.length,
        totalNodes: tempNodeLinks.length,
      ),
    )) {
      return null;
    }

    // Apply topology changes to LSDB
    final updatedLSDB = _applyTopologyChanges(
      currentTable.topology,
      topologyChanges,
    );

    // Recompute routes using the updated LSDB
    final updatedRoutes = _computeOptimalRoutes(
      updatedLSDB,
      currentTable.sourceNode,
    );

    // Compress paths if enabled
    if (enablePathCompression) {
      _compressPaths(updatedRoutes);
    }

    return LinkStateRoutingTable<T>(
      sourceNode: currentTable.sourceNode,
      routes: Map.unmodifiable(updatedRoutes),
      topology: updatedLSDB,
      lastUpdate: DateTime.now(),
      totalRoutes: updatedRoutes.length,
      totalNodes: currentTable.totalNodes,
    );
  }

  /// Applies topology changes to the link-state database
  LinkStateDatabase<T> _applyTopologyChanges(
    LinkStateDatabase<T> currentLSDB,
    List<LinkStateEntry<T>> changes,
  ) {
    final updatedNodeLinks = Map<T, List<LinkStateEntry<T>>>.from(
      currentLSDB.nodeLinks,
    );

    for (final change in changes) {
      final source = change.sourceNode;
      final target = change.targetNode;

      // Update forward link (source -> target)
      if (updatedNodeLinks.containsKey(source)) {
        final sourceLinks = updatedNodeLinks[source]!;
        // Remove all existing links to the target
        sourceLinks.removeWhere((link) => link.targetNode == target);
        // Add the new link
        sourceLinks.add(change);
      } else {
        // Create new source node with the link
        updatedNodeLinks[source] = [change];
      }

      // Update reverse link (target -> source) if bidirectional
      if (change.isActive && change.attributes['bidirectional'] == true) {
        final reverseLink = change.copyWith(
          sourceNode: target,
          targetNode: source,
        );

        if (updatedNodeLinks.containsKey(target)) {
          final targetLinks = updatedNodeLinks[target]!;
          // Remove all existing links to the source
          targetLinks.removeWhere((link) => link.targetNode == source);
          // Add the new reverse link
          targetLinks.add(reverseLink);
        } else {
          // Create new target node with the reverse link
          updatedNodeLinks[target] = [reverseLink];
        }
      }
    }

    // Recalculate totals
    int totalLinks = 0;
    for (final links in updatedNodeLinks.values) {
      totalLinks += links.length;
    }

    return LinkStateDatabase<T>(
      nodeLinks: updatedNodeLinks,
      lastUpdate: DateTime.now(),
      totalLinks: totalLinks,
      totalNodes: updatedNodeLinks.length,
    );
  }

  /// Checks if topology changes are significant enough to trigger recomputation
  bool _hasSignificantChanges(
    LinkStateDatabase<T> oldLSDB,
    LinkStateDatabase<T> newLSDB,
  ) {
    // Check if number of active links changed significantly
    final oldActiveCount = oldLSDB.activeLinkCount;
    final newActiveCount = newLSDB.activeLinkCount;

    // Check if any link costs changed significantly
    bool hasCostChanges = false;
    for (final node in oldLSDB.nodeLinks.keys) {
      final oldLinks = oldLSDB.nodeLinks[node] ?? [];
      final newLinks = newLSDB.nodeLinks[node] ?? [];

      for (final oldLink in oldLinks) {
        final newLink = newLinks.firstWhere(
          (link) => link.targetNode == oldLink.targetNode,
          orElse: () => oldLink,
        );

        // Check if the cost changed significantly (more than 0.1 difference)
        if ((newLink.linkCost - oldLink.linkCost).abs() > 0.1) {
          hasCostChanges = true;
          break;
        }
      }
      if (hasCostChanges) break;
    }

    final changeRatio =
        oldActiveCount > 0
            ? (newActiveCount - oldActiveCount).abs() / oldActiveCount
            : 0.0;

    return changeRatio > 0.1 ||
        hasCostChanges; // 10% change threshold or any cost change
  }

  /// Gets comprehensive statistics for monitoring and analysis
  ///
  /// [routingTable] - Routing table to analyze
  ///
  /// Returns map with various statistics
  Map<String, dynamic> getLinkStateStatistics(
    LinkStateRoutingTable<T> routingTable,
  ) {
    final routes = routingTable.routes.values;
    final costs = routes.map((r) => r.cost).toList();
    final hopCounts = routes.map((r) => r.hopCount).toList();

    return {
      'totalRoutes': routes.length,
      'totalNodes': routingTable.totalNodes,
      'directlyConnected': routes.where((r) => r.isDirectlyConnected).length,
      'indirectRoutes': routes.where((r) => !r.isDirectlyConnected).length,
      'activeRoutes': routes.where((r) => r.isActive).length,
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
      'topologySize': routingTable.topology.totalLinks,
      'activeLinks': routingTable.topology.activeLinkCount,
      'failedLinks': routingTable.topology.failedLinkCount,
      'networkDensity':
          routingTable.topology.totalLinks /
          (routingTable.totalNodes * (routingTable.totalNodes - 1)),
    };
  }

  /// Validates link-state routing table consistency
  ///
  /// [routingTable] - Routing table to validate
  /// [network] - Network topology for validation
  ///
  /// Returns list of validation errors (empty if valid)
  List<String> validateLinkStateTable(
    LinkStateRoutingTable<T> routingTable,
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
      if (route.path.length > 1 && route.path.first == route.path.last) {
        errors.add('Circular route detected: ${route.path}');
      }
    }

    // Check topology consistency
    for (final route in routingTable.routes.values) {
      for (int i = 0; i < route.path.length - 1; i++) {
        final current = route.path[i];
        final next = route.path[i + 1];
        if (!routingTable.topology.hasLink(current, next)) {
          errors.add(
            'Invalid path: link $current -> $next does not exist in topology',
          );
        }
      }
    }

    return errors;
  }
}

/// Convenience function for quick link-state route computation
///
/// [network] - Network topology as adjacency list
/// [sourceNode] - Source node for routing table
/// [topologyOptimizations] - Optional topology optimization parameters
///
/// Returns complete link-state routing table from source node
///
/// Throws [ArgumentError] if source node doesn't exist in network
LinkStateRoutingTable<T> computeLinkStateRoutes<T>(
  Map<T, Map<T, num>> network,
  T sourceNode, {
  Map<String, dynamic>? topologyOptimizations,
}) {
  return LinkStateRoutingAlgorithm<T>().computeRoutes(
    network,
    sourceNode,
    topologyOptimizations: topologyOptimizations,
  );
}
