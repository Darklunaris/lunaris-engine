import 'package:test/test.dart';
import 'package:lunaris_engine/RoutingNET/distance_vector_routing.dart';

void main() {
  group('Distance-Vector Routing Algorithm Tests', () {
    late Map<String, Map<String, num>> testNetwork;
    late DistanceVectorRoutingAlgorithm<String> dvrAlgorithm;

    setUp(() {
      testNetwork = <String, Map<String, num>>{
        'A': {'B': 1, 'C': 1},
        'B': {'A': 1, 'C': 1, 'D': 1},
        'C': {'A': 1, 'B': 1, 'D': 1},
        'D': {'B': 1, 'C': 1, 'E': 1},
        'E': {'D': 1, 'F': 1},
        'F': {'E': 1, 'G': 1},
        'G': {'F': 1, 'H': 1},
        'H': {'G': 1},
      };
      dvrAlgorithm = DistanceVectorRoutingAlgorithm<String>();
    });

    group('DistanceVectorRouteEntry Tests', () {
      test('Creates route entry with correct properties', () {
        final now = DateTime.now();
        final route = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5.0,
          lastUpdate: now,
          isDirectlyConnected: false,
          advertisingNeighbor: 'C',
          hopCount: 2,
          attributes: {'timeout': Duration(seconds: 180)},
        );

        expect(route.destination, equals('B'));
        expect(route.nextHop, equals('A'));
        expect(route.cost, equals(5.0));
        expect(route.lastUpdate, equals(now));
        expect(route.isDirectlyConnected, isFalse);
        expect(route.advertisingNeighbor, equals('C'));
        expect(route.hopCount, equals(2));
        expect(route.attributes['timeout'], equals(Duration(seconds: 180)));
      });

      test('copyWith creates new instance with updated values', () {
        final original = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
          advertisingNeighbor: 'C',
          hopCount: 2,
        );

        final updated = original.copyWith(
          cost: 10.0,
          nextHop: 'D',
          hopCount: 3,
        );

        expect(updated.destination, equals('B'));
        expect(updated.nextHop, equals('D'));
        expect(updated.cost, equals(10.0));
        expect(updated.hopCount, equals(3));
        expect(updated, isNot(same(original)));
      });

      test('updateFromNeighbor updates route correctly', () {
        final route = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
          advertisingNeighbor: 'C',
          hopCount: 2,
        );

        final updated = route.updateFromNeighbor('D', 8.0, 3);

        expect(updated.cost, equals(8.0));
        expect(updated.hopCount, equals(3));
        expect(updated.advertisingNeighbor, equals('D'));
        expect(updated.lastUpdate, isNot(equals(route.lastUpdate)));
      });

      test('isStale returns correct status', () {
        final oldRoute = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5.0,
          lastUpdate: DateTime.now().subtract(Duration(seconds: 300)),
          isDirectlyConnected: false,
          advertisingNeighbor: 'C',
          hopCount: 2,
          attributes: {'timeout': Duration(seconds: 180)},
        );

        final recentRoute = DistanceVectorRouteEntry<String>(
          destination: 'C',
          nextHop: 'A',
          cost: 4.0,
          lastUpdate: DateTime.now().subtract(Duration(seconds: 30)),
          isDirectlyConnected: false,
          advertisingNeighbor: 'B',
          hopCount: 1,
          attributes: {'timeout': Duration(seconds: 180)},
        );

        expect(oldRoute.isStale, isTrue);
        expect(recentRoute.isStale, isFalse);
      });

      test('isValid returns correct status', () {
        final validRoute = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
          advertisingNeighbor: 'C',
          hopCount: 2,
        );

        final staleRoute = DistanceVectorRouteEntry<String>(
          destination: 'C',
          nextHop: 'A',
          cost: 4.0,
          lastUpdate: DateTime.now().subtract(Duration(seconds: 300)),
          isDirectlyConnected: false,
          advertisingNeighbor: 'B',
          hopCount: 1,
          attributes: {'timeout': Duration(seconds: 180)},
        );

        final invalidCostRoute = DistanceVectorRouteEntry<String>(
          destination: 'D',
          nextHop: 'A',
          cost: -1.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
          advertisingNeighbor: 'C',
          hopCount: 2,
        );

        expect(validRoute.isValid, isTrue);
        expect(staleRoute.isValid, isFalse);
        expect(invalidCostRoute.isValid, isFalse);
      });

      test('equality and hashCode work correctly', () {
        final route1 = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
          advertisingNeighbor: 'C',
          hopCount: 2,
        );

        final route2 = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5.0, // Same cost
          lastUpdate:
              DateTime.now(), // Different time (should not affect equality)
          isDirectlyConnected:
              false, // Different direct status (should not affect equality)
          advertisingNeighbor:
              'D', // Different neighbor (should not affect equality)
          hopCount: 3, // Different hop count (should not affect equality)
        );

        expect(route1, equals(route2));
        expect(route1.hashCode, equals(route2.hashCode));
      });
    });

    group('NeighborAdvertisement Tests', () {
      test('Creates advertisement with correct properties', () {
        final now = DateTime.now();
        final distanceVector = <String, num>{'B': 0, 'C': 2, 'D': 5};
        final advertisement = NeighborAdvertisement<String>(
          neighbor: 'A',
          distanceVector: distanceVector,
          timestamp: now,
          sequenceNumber: 1,
          metadata: {'maxAge': Duration(seconds: 60)},
        );

        expect(advertisement.neighbor, equals('A'));
        expect(advertisement.distanceVector, equals(distanceVector));
        expect(advertisement.timestamp, equals(now));
        expect(advertisement.sequenceNumber, equals(1));
        expect(advertisement.metadata['maxAge'], equals(Duration(seconds: 60)));
      });

      test('copyWith creates new instance with updated values', () {
        final original = NeighborAdvertisement<String>(
          neighbor: 'A',
          distanceVector: <String, num>{'B': 0},
          timestamp: DateTime.now(),
          sequenceNumber: 1,
        );

        final updated = original.copyWith(
          sequenceNumber: 2,
          distanceVector: <String, num>{'B': 0, 'C': 2},
        );

        expect(updated.neighbor, equals('A'));
        expect(updated.sequenceNumber, equals(2));
        expect(updated.distanceVector.length, equals(2));
        expect(updated, isNot(same(original)));
      });

      test('isRecent returns correct status', () {
        final recentAd = NeighborAdvertisement<String>(
          neighbor: 'A',
          distanceVector: <String, num>{'B': 0},
          timestamp: DateTime.now().subtract(Duration(seconds: 30)),
          sequenceNumber: 1,
          metadata: {'maxAge': Duration(seconds: 60)},
        );

        final oldAd = NeighborAdvertisement<String>(
          neighbor: 'B',
          distanceVector: <String, num>{'C': 0},
          timestamp: DateTime.now().subtract(Duration(seconds: 90)),
          sequenceNumber: 1,
          metadata: {'maxAge': Duration(seconds: 60)},
        );

        expect(recentAd.isRecent, isTrue);
        expect(oldAd.isRecent, isFalse);
      });

      test('getCostTo returns correct cost', () {
        final advertisement = NeighborAdvertisement<String>(
          neighbor: 'A',
          distanceVector: <String, num>{'B': 0, 'C': 2, 'D': 5},
          timestamp: DateTime.now(),
          sequenceNumber: 1,
        );

        expect(advertisement.getCostTo('B'), equals(0));
        expect(advertisement.getCostTo('C'), equals(2));
        expect(advertisement.getCostTo('D'), equals(5));
        expect(advertisement.getCostTo('E'), isNull);
      });

      test('equality and hashCode work correctly', () {
        final ad1 = NeighborAdvertisement<String>(
          neighbor: 'A',
          distanceVector: <String, num>{'B': 0},
          timestamp: DateTime.now(),
          sequenceNumber: 1,
        );

        final ad2 = NeighborAdvertisement<String>(
          neighbor: 'A',
          distanceVector: <String, num>{'B': 5}, // Different cost
          timestamp: DateTime.now(), // Different time
          sequenceNumber: 1, // Same sequence number
        );

        expect(ad1, equals(ad2));
        expect(ad1.hashCode, equals(ad2.hashCode));
      });
    });

    group('DistanceVectorRoutingTable Tests', () {
      test('Creates routing table with correct properties', () {
        final routes = <String, DistanceVectorRouteEntry<String>>{};
        final neighborAds = <String, NeighborAdvertisement<String>>{};
        final now = DateTime.now();

        final table = DistanceVectorRoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          neighborAdvertisements: neighborAds,
          lastUpdate: now,
          totalRoutes: 0,
          totalNeighbors: 0,
        );

        expect(table.sourceNode, equals('A'));
        expect(table.routes, equals(routes));
        expect(table.neighborAdvertisements, equals(neighborAds));
        expect(table.lastUpdate, equals(now));
        expect(table.totalRoutes, equals(0));
        expect(table.totalNeighbors, equals(0));
      });

      test('getRoute returns correct route', () {
        final route = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'B',
          cost: 1.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: true,
          advertisingNeighbor: 'B',
          hopCount: 1,
        );

        final routes = <String, DistanceVectorRouteEntry<String>>{'B': route};
        final neighborAds = <String, NeighborAdvertisement<String>>{};

        final table = DistanceVectorRoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          neighborAdvertisements: neighborAds,
          lastUpdate: DateTime.now(),
          totalRoutes: 1,
          totalNeighbors: 0,
        );

        expect(table.getRoute('B'), equals(route));
        expect(table.getRoute('C'), isNull);
      });

      test('validRoutes returns only valid routes', () {
        final validRoute = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'B',
          cost: 1.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: true,
          advertisingNeighbor: 'B',
          hopCount: 1,
        );

        final staleRoute = DistanceVectorRouteEntry<String>(
          destination: 'C',
          nextHop: 'B',
          cost: 5.0,
          lastUpdate: DateTime.now().subtract(Duration(seconds: 300)),
          isDirectlyConnected: false,
          advertisingNeighbor: 'B',
          hopCount: 2,
          attributes: {'timeout': Duration(seconds: 180)},
        );

        final routes = <String, DistanceVectorRouteEntry<String>>{
          'B': validRoute,
          'C': staleRoute,
        };

        final neighborAds = <String, NeighborAdvertisement<String>>{};

        final table = DistanceVectorRoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          neighborAdvertisements: neighborAds,
          lastUpdate: DateTime.now(),
          totalRoutes: 2,
          totalNeighbors: 0,
        );

        final validRoutes = table.validRoutes;
        expect(validRoutes.length, equals(1));
        expect(validRoutes, contains(validRoute));
        expect(validRoutes, isNot(contains(staleRoute)));
      });

      test('getRoutesFromNeighbor returns correct routes', () {
        final route1 = DistanceVectorRouteEntry<String>(
          destination: 'B',
          nextHop: 'B',
          cost: 1.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: true,
          advertisingNeighbor: 'B',
          hopCount: 1,
        );

        final route2 = DistanceVectorRouteEntry<String>(
          destination: 'C',
          nextHop: 'B',
          cost: 5.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
          advertisingNeighbor: 'B',
          hopCount: 2,
        );

        final route3 = DistanceVectorRouteEntry<String>(
          destination: 'D',
          nextHop: 'C',
          cost: 8.0,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
          advertisingNeighbor: 'C',
          hopCount: 3,
        );

        final routes = <String, DistanceVectorRouteEntry<String>>{
          'B': route1,
          'C': route2,
          'D': route3,
        };

        final neighborAds = <String, NeighborAdvertisement<String>>{};

        final table = DistanceVectorRoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          neighborAdvertisements: neighborAds,
          lastUpdate: DateTime.now(),
          totalRoutes: 3,
          totalNeighbors: 0,
        );

        final routesFromB = table.getRoutesFromNeighbor('B');
        expect(routesFromB.length, equals(2));
        expect(routesFromB, contains(route1));
        expect(routesFromB, contains(route2));

        final routesFromC = table.getRoutesFromNeighbor('C');
        expect(routesFromC.length, equals(1));
        expect(routesFromC, contains(route3));
      });

      test('neighbors returns all neighbor nodes', () {
        final routes = <String, DistanceVectorRouteEntry<String>>{};
        final neighborAds = <String, NeighborAdvertisement<String>>{
          'B': NeighborAdvertisement<String>(
            neighbor: 'B',
            distanceVector: <String, num>{'B': 0},
            timestamp: DateTime.now(),
            sequenceNumber: 1,
          ),
          'C': NeighborAdvertisement<String>(
            neighbor: 'C',
            distanceVector: <String, num>{'C': 0},
            timestamp: DateTime.now(),
            sequenceNumber: 1,
          ),
        };

        final table = DistanceVectorRoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          neighborAdvertisements: neighborAds,
          lastUpdate: DateTime.now(),
          totalRoutes: 0,
          totalNeighbors: 2,
        );

        final neighbors = table.neighbors;
        expect(neighbors.length, equals(2));
        expect(neighbors, contains('B'));
        expect(neighbors, contains('C'));
      });
    });

    group('DistanceVectorRoutingAlgorithm Tests', () {
      test('Creates algorithm with default parameters', () {
        expect(dvrAlgorithm.updateInterval, equals(Duration(seconds: 30)));
        expect(dvrAlgorithm.routeTimeout, equals(Duration(seconds: 180)));
        expect(dvrAlgorithm.maxIterations, equals(100));
        expect(dvrAlgorithm.enableSplitHorizon, isTrue);
        expect(dvrAlgorithm.enablePoisonReverse, isTrue);
        expect(dvrAlgorithm.enableTriggeredUpdates, isTrue);
      });

      test('Creates algorithm with custom parameters', () {
        final customDvr = DistanceVectorRoutingAlgorithm<String>(
          updateInterval: Duration(seconds: 60),
          routeTimeout: Duration(seconds: 300),
          maxIterations: 200,
          enableSplitHorizon: false,
          enablePoisonReverse: false,
          enableTriggeredUpdates: false,
        );

        expect(customDvr.updateInterval, equals(Duration(seconds: 60)));
        expect(customDvr.routeTimeout, equals(Duration(seconds: 300)));
        expect(customDvr.maxIterations, equals(200));
        expect(customDvr.enableSplitHorizon, isFalse);
        expect(customDvr.enablePoisonReverse, isFalse);
        expect(customDvr.enableTriggeredUpdates, isFalse);
      });

      test('computeRoutes throws error for non-existent source node', () {
        expect(
          () => dvrAlgorithm.computeRoutes(testNetwork, 'Z'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('computeRoutes creates routing table for source node', () {
        final routes = dvrAlgorithm.computeRoutes(testNetwork, 'A');

        expect(routes.sourceNode, equals('A'));
        expect(routes.totalRoutes, greaterThan(0));
        expect(routes.totalNeighbors, greaterThan(0));
        expect(routes.lastUpdate, isA<DateTime>());
      });

      test('computeRoutes includes self-route with zero cost', () {
        final routes = dvrAlgorithm.computeRoutes(testNetwork, 'A');
        final selfRoute = routes.getRoute('A');

        expect(selfRoute, isNotNull);
        expect(selfRoute!.cost, equals(0));
        expect(selfRoute.isDirectlyConnected, isTrue);
        expect(selfRoute.nextHop, isNull);
        expect(selfRoute.hopCount, equals(0));
      });

      test('computeRoutes includes directly connected neighbors', () {
        final routes = dvrAlgorithm.computeRoutes(testNetwork, 'A');

        final routeB = routes.getRoute('B');
        final routeC = routes.getRoute('C');

        expect(routeB, isNotNull);
        expect(routeB!.isDirectlyConnected, isTrue);
        expect(routeB.cost, equals(1));
        expect(routeB.hopCount, equals(1));

        expect(routeC, isNotNull);
        expect(routeC!.isDirectlyConnected, isTrue);
        expect(routeC.cost, equals(1));
        expect(routeC.hopCount, equals(1));
      });

      test('computeRoutes finds routes to distant nodes', () {
        final routes = dvrAlgorithm.computeRoutes(testNetwork, 'A');

        final routeE = routes.getRoute('E');
        final routeH = routes.getRoute('H');

        expect(routeE, isNotNull);
        expect(routeE!.isDirectlyConnected, isFalse);
        expect(routeE.cost, greaterThan(1));
        expect(routeE.hopCount, greaterThan(1));

        expect(routeH, isNotNull);
        expect(routeH!.isDirectlyConnected, isFalse);
        expect(routeH.cost, greaterThan(1));
        expect(routeH.hopCount, greaterThan(1));
      });

      test('computeRoutes with initial advertisements', () {
        final initialAds = <String, NeighborAdvertisement<String>>{
          'B': NeighborAdvertisement<String>(
            neighbor: 'B',
            distanceVector: <String, num>{'B': 0, 'D': 5, 'E': 8},
            timestamp: DateTime.now(),
            sequenceNumber: 1,
          ),
        };

        final routes = dvrAlgorithm.computeRoutes(
          testNetwork,
          'A',
          initialAdvertisements: initialAds,
        );

        expect(routes.totalRoutes, greaterThan(0));
        expect(routes.totalNeighbors, greaterThan(0));
      });

      test('updateFromNeighborAdvertisements updates routing table', () {
        final currentTable = dvrAlgorithm.computeRoutes(testNetwork, 'A');
        final now = DateTime.now();

        final advertisements = <String, NeighborAdvertisement<String>>{
          'X': NeighborAdvertisement<String>(
            neighbor: 'X',
            distanceVector: <String, num>{'X': 0, 'Y': 2},
            timestamp: now,
            sequenceNumber: 1,
          ),
        };

        final updatedTable = dvrAlgorithm.updateFromNeighborAdvertisements(
          currentTable,
          advertisements,
          testNetwork,
        );

        expect(updatedTable, isNotNull);
        expect(
          updatedTable!.totalRoutes,
          greaterThan(currentTable.totalRoutes),
        );
      });

      test('processNeighborUpdate processes single update', () {
        final currentTable = dvrAlgorithm.computeRoutes(testNetwork, 'A');
        final now = DateTime.now();

        final advertisement = NeighborAdvertisement<String>(
          neighbor: 'X',
          distanceVector: <String, num>{'X': 0, 'Y': 2},
          timestamp: now,
          sequenceNumber: 1,
        );

        final updatedTable = dvrAlgorithm.processNeighborUpdate(
          currentTable,
          advertisement,
          testNetwork,
        );

        expect(updatedTable, isNotNull);
        expect(
          updatedTable!.totalRoutes,
          greaterThan(currentTable.totalRoutes),
        );
      });

      test('cleanupStaleRoutes removes old routes', () {
        final routes = dvrAlgorithm.computeRoutes(testNetwork, 'A');
        final currentTime = DateTime.now();

        final cleanedRoutes = dvrAlgorithm.cleanupStaleRoutes(
          routes,
          currentTime,
        );

        expect(
          cleanedRoutes.totalRoutes,
          lessThanOrEqualTo(routes.totalRoutes),
        );
        expect(
          cleanedRoutes.totalNeighbors,
          lessThanOrEqualTo(routes.totalNeighbors),
        );
      });

      test('getDistanceVectorStatistics returns comprehensive statistics', () {
        final routes = dvrAlgorithm.computeRoutes(testNetwork, 'A');
        final stats = dvrAlgorithm.getDistanceVectorStatistics(routes);

        expect(stats['totalRoutes'], isNotNull);
        expect(stats['totalNeighbors'], isNotNull);
        expect(stats['directlyConnected'], isNotNull);
        expect(stats['indirectRoutes'], isNotNull);
        expect(stats['validRoutes'], isNotNull);
        expect(stats['staleRoutes'], isNotNull);
        expect(stats['averageCost'], isNotNull);
        expect(stats['maxCost'], isNotNull);
        expect(stats['minCost'], isNotNull);
        expect(stats['averageHopCount'], isNotNull);
        expect(stats['maxHopCount'], isNotNull);
        expect(stats['neighborUpdateFrequency'], isNotNull);
        expect(stats['recentAdvertisements'], isNotNull);
        expect(stats['convergenceStatus'], isNotNull);
      });

      test(
        'validateDistanceVectorTable returns empty list for valid table',
        () {
          final routes = dvrAlgorithm.computeRoutes(testNetwork, 'A');
          final errors = dvrAlgorithm.validateDistanceVectorTable(
            routes,
            testNetwork,
          );

          expect(errors, isEmpty);
        },
      );

      test('validateDistanceVectorTable detects invalid source node', () {
        final routes = DistanceVectorRoutingTable<String>(
          sourceNode: 'Z',
          routes: <String, DistanceVectorRouteEntry<String>>{},
          neighborAdvertisements: <String, NeighborAdvertisement<String>>{},
          lastUpdate: DateTime.now(),
          totalRoutes: 0,
          totalNeighbors: 0,
        );

        final errors = dvrAlgorithm.validateDistanceVectorTable(
          routes,
          testNetwork,
        );

        expect(errors, isNotEmpty);
        expect(errors.first, contains('Source node Z not found'));
      });

      test('needsUpdate returns correct status', () {
        final routes = DistanceVectorRoutingTable<String>(
          sourceNode: 'A',
          routes: <String, DistanceVectorRouteEntry<String>>{},
          neighborAdvertisements: <String, NeighborAdvertisement<String>>{},
          lastUpdate: DateTime.now().subtract(Duration(seconds: 60)),
          totalRoutes: 0,
          totalNeighbors: 0,
        );

        final needsUpdate = dvrAlgorithm.needsUpdate(routes, DateTime.now());

        expect(needsUpdate, isTrue);
      });

      test('getNextUpdateTime returns correct time', () {
        final now = DateTime.now();
        final routes = DistanceVectorRoutingTable<String>(
          sourceNode: 'A',
          routes: <String, DistanceVectorRouteEntry<String>>{},
          neighborAdvertisements: <String, NeighborAdvertisement<String>>{},
          lastUpdate: now,
          totalRoutes: 0,
          totalNeighbors: 0,
        );

        final nextUpdate = dvrAlgorithm.getNextUpdateTime(routes);
        final expectedTime = now.add(Duration(seconds: 30));

        expect(nextUpdate.difference(expectedTime).inSeconds, lessThan(1));
      });
    });

    group('Convenience Function Tests', () {
      test('computeDistanceVectorRoutes works correctly', () {
        final routes = computeDistanceVectorRoutes(testNetwork, 'A');

        expect(routes.sourceNode, equals('A'));
        expect(routes.totalRoutes, greaterThan(0));
        expect(routes.getRoute('A'), isNotNull);
        expect(routes.getRoute('B'), isNotNull);
      });

      test('computeDistanceVectorRoutes with initial advertisements', () {
        final initialAds = <String, NeighborAdvertisement<String>>{
          'B': NeighborAdvertisement<String>(
            neighbor: 'B',
            distanceVector: <String, num>{'B': 0, 'D': 5},
            timestamp: DateTime.now(),
            sequenceNumber: 1,
          ),
        };

        final routes = computeDistanceVectorRoutes(
          testNetwork,
          'A',
          initialAdvertisements: initialAds,
        );

        expect(routes.sourceNode, equals('A'));
        expect(routes.totalRoutes, greaterThan(0));
      });
    });

    group('Edge Cases and Error Handling', () {
      test('Handles empty network gracefully', () {
        final emptyNetwork = <String, Map<String, num>>{};
        expect(
          () => dvrAlgorithm.computeRoutes(emptyNetwork, 'A'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('Handles single node network', () {
        final singleNodeNetwork = <String, Map<String, num>>{
          'A': <String, num>{},
        };
        final routes = dvrAlgorithm.computeRoutes(singleNodeNetwork, 'A');

        expect(routes.totalRoutes, equals(1)); // Only self-route
        expect(routes.getRoute('A'), isNotNull);
      });

      test('Handles disconnected nodes', () {
        final disconnectedNetwork = <String, Map<String, num>>{
          'A': {'B': 1},
          'B': {'A': 1},
          'C': <String, num>{}, // Disconnected
        };

        final routes = dvrAlgorithm.computeRoutes(disconnectedNetwork, 'A');

        expect(routes.getRoute('A'), isNotNull);
        expect(routes.getRoute('B'), isNotNull);
        expect(routes.getRoute('C'), isNull); // Should not be reachable
      });

      // test('Handles negative costs gracefully', () {
      //   final negativeCostNetwork = <String, Map<String, num>>{
      //     'A': {'B': -1, 'C': 4},
      //     'B': {'A': -1, 'C': 2},
      //     'C': {'A': 4, 'B': 2},
      //   };

      //   final routes = dvrAlgorithm.computeRoutes(negativeCostNetwork, 'A');

      //   expect(routes.totalRoutes, greaterThan(0));
      //   // Should handle negative costs appropriately
      // });
    });

    group('Performance Tests', () {
      test('Handles large networks efficiently', () {
        final largeNetwork = <String, Map<String, num>>{};

        // Create a 100-node network
        for (int i = 0; i < 100; i++) {
          final node = 'Node$i';
          largeNetwork[node] = <String, num>{};

          // Connect to a few random nodes
          for (int j = 0; j < 3; j++) {
            final target = (i + j + 1) % 100;
            if (target != i) {
              largeNetwork[node]!['Node$target'] = 1;
            }
          }
        }

        final stopwatch = Stopwatch()..start();
        final routes = dvrAlgorithm.computeRoutes(largeNetwork, 'Node0');
        stopwatch.stop();

        expect(routes.totalRoutes, greaterThan(0));
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1000),
        ); // Should complete in under 1 second
      });

      test('Converges in reasonable number of iterations', () {
        final complexNetwork = <String, Map<String, num>>{
          'A': {'B': 1, 'C': 1},
          'B': {'A': 1, 'D': 1, 'E': 1},
          'C': {'A': 1, 'F': 1, 'G': 1},
          'D': {'B': 1, 'H': 1},
          'E': {'B': 1, 'I': 1},
          'F': {'C': 1, 'J': 1},
          'G': {'C': 1, 'K': 1},
          'H': {'D': 1, 'L': 1},
          'I': {'E': 1, 'M': 1},
          'J': {'F': 1, 'N': 1},
          'K': {'G': 1, 'O': 1},
          'L': {'H': 1},
          'M': {'I': 1},
          'N': {'J': 1},
          'O': {'K': 1},
        };

        final routes = dvrAlgorithm.computeRoutes(complexNetwork, 'A');

        expect(routes.totalRoutes, equals(15)); // All nodes should be reachable
        expect(
          routes.getRoute('L'),
          isNotNull,
        ); // Should find route to distant node
        expect(
          routes.getRoute('L')!.cost,
          greaterThan(1),
        ); // Should not be direct
      });
    });
  });
}
