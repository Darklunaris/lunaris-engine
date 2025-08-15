import 'package:test/test.dart';
import 'package:lunaris_engine/RoutingNET/rip_algorithm.dart';

void main() {
  group('RIP Algorithm Tests', () {
    late Map<String, Map<String, num>> testNetwork;
    late RIPAlgorithm<String> ripAlgorithm;

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
      ripAlgorithm = RIPAlgorithm<String>();
    });

    group('RouteEntry Tests', () {
      test('Creates route entry with correct properties', () {
        final now = DateTime.now();
        final route = RouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5,
          lastUpdate: now,
          isDirectlyConnected: false,
        );

        expect(route.destination, equals('B'));
        expect(route.nextHop, equals('A'));
        expect(route.cost, equals(5));
        expect(route.lastUpdate, equals(now));
        expect(route.isDirectlyConnected, isFalse);
      });

      test('copyWith creates new instance with updated values', () {
        final original = RouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
        );

        final updated = original.copyWith(cost: 10, nextHop: 'C');

        expect(updated.destination, equals('B'));
        expect(updated.nextHop, equals('C'));
        expect(updated.cost, equals(10));
        expect(updated.isDirectlyConnected, isFalse);
        expect(updated, isNot(same(original)));
      });

      test('equality and hashCode work correctly', () {
        final route1 = RouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
        );

        final route2 = RouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5,
          lastUpdate: route1.lastUpdate,
          isDirectlyConnected: false,
        );

        expect(route1, equals(route2));
        expect(route1.hashCode, equals(route2.hashCode));
      });
    });

    group('RoutingTable Tests', () {
      test('Creates routing table with correct properties', () {
        final routes = <String, RouteEntry<String>>{};
        final now = DateTime.now();
        final table = RoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          lastUpdate: now,
        );

        expect(table.sourceNode, equals('A'));
        expect(table.routes, equals(routes));
        expect(table.lastUpdate, equals(now));
        expect(table.routeCount, equals(0));
      });

      test('getRoute returns correct route', () {
        final route = RouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
        );

        final routes = <String, RouteEntry<String>>{'B': route};
        final table = RoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          lastUpdate: DateTime.now(),
        );

        expect(table.getRoute('B'), equals(route));
        expect(table.getRoute('C'), isNull);
      });

      test('allRoutes returns all routes as list', () {
        final route1 = RouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
        );

        final route2 = RouteEntry<String>(
          destination: 'C',
          nextHop: 'A',
          cost: 10,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
        );

        final routes = <String, RouteEntry<String>>{'B': route1, 'C': route2};
        final table = RoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          lastUpdate: DateTime.now(),
        );

        final allRoutes = table.allRoutes;
        expect(allRoutes.length, equals(2));
        expect(allRoutes, contains(route1));
        expect(allRoutes, contains(route2));
      });

      test('getRoutesByCost filters routes correctly', () {
        final route1 = RouteEntry<String>(
          destination: 'B',
          nextHop: 'A',
          cost: 5,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
        );

        final route2 = RouteEntry<String>(
          destination: 'C',
          nextHop: 'A',
          cost: 7,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
        );

        final route3 = RouteEntry<String>(
          destination: 'D',
          nextHop: 'A',
          cost: 15,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
        );

        final routes = <String, RouteEntry<String>>{
          'B': route1,
          'C': route2,
          'D': route3,
        };

        final table = RoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          lastUpdate: DateTime.now(),
        );

        final lowCostRoutes = table.getRoutesByCost(8);
        expect(lowCostRoutes.length, equals(2));
        expect(lowCostRoutes, contains(route1));
        expect(lowCostRoutes, contains(route2));
        expect(lowCostRoutes, isNot(contains(route3)));
      });

      test('directlyConnectedRoutes returns only direct routes', () {
        final directRoute = RouteEntry<String>(
          destination: 'B',
          nextHop: 'B',
          cost: 1,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: true,
        );

        final indirectRoute = RouteEntry<String>(
          destination: 'C',
          nextHop: 'B',
          cost: 6,
          lastUpdate: DateTime.now(),
          isDirectlyConnected: false,
        );

        final routes = <String, RouteEntry<String>>{
          'B': directRoute,
          'C': indirectRoute,
        };

        final table = RoutingTable<String>(
          sourceNode: 'A',
          routes: routes,
          lastUpdate: DateTime.now(),
        );

        final directRoutes = table.directlyConnectedRoutes;
        expect(directRoutes.length, equals(1));
        expect(directRoutes, contains(directRoute));
        expect(directRoutes, isNot(contains(indirectRoute)));
      });
    });

    group('RIPAlgorithm Tests', () {
      test('Creates RIP algorithm with default parameters', () {
        expect(ripAlgorithm.updateInterval, equals(Duration(seconds: 30)));
        expect(ripAlgorithm.routeTimeout, equals(Duration(seconds: 180)));
        expect(
          ripAlgorithm.garbageCollectionTimeout,
          equals(Duration(seconds: 120)),
        );
        expect(ripAlgorithm.maxIterations, equals(100));
      });

      test('Creates RIP algorithm with custom parameters', () {
        final customRip = RIPAlgorithm<String>(
          updateInterval: Duration(seconds: 60),
          routeTimeout: Duration(seconds: 300),
          garbageCollectionTimeout: Duration(seconds: 240),
          maxIterations: 200,
        );

        expect(customRip.updateInterval, equals(Duration(seconds: 60)));
        expect(customRip.routeTimeout, equals(Duration(seconds: 300)));
        expect(
          customRip.garbageCollectionTimeout,
          equals(Duration(seconds: 240)),
        );
        expect(customRip.maxIterations, equals(200));
      });

      test('computeRoutes throws error for non-existent source node', () {
        expect(
          () => ripAlgorithm.computeRoutes(testNetwork, 'Z'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('computeRoutes creates routing table for source node', () {
        final routes = ripAlgorithm.computeRoutes(testNetwork, 'A');

        expect(routes.sourceNode, equals('A'));
        expect(routes.routeCount, greaterThan(0));
        expect(routes.lastUpdate, isA<DateTime>());
      });

      test('computeRoutes includes self-route with zero cost', () {
        final routes = ripAlgorithm.computeRoutes(testNetwork, 'A');
        final selfRoute = routes.getRoute('A');

        expect(selfRoute, isNotNull);
        expect(selfRoute!.cost, equals(0));
        expect(selfRoute.isDirectlyConnected, isTrue);
        expect(selfRoute.nextHop, isNull);
      });

      test('computeRoutes includes directly connected neighbors', () {
        final routes = ripAlgorithm.computeRoutes(testNetwork, 'A');

        final routeB = routes.getRoute('B');
        final routeC = routes.getRoute('C');

        expect(routeB, isNotNull);
        expect(routeB!.isDirectlyConnected, isTrue);
        expect(routeB.cost, equals(1));

        expect(routeC, isNotNull);
        expect(
          routeC!.isDirectlyConnected,
          isTrue,
        ); // Direct connection with cost 1
        expect(routeC.cost, equals(1)); // Direct connection
      });

      test('computeRoutes finds routes to distant nodes', () {
        final routes = ripAlgorithm.computeRoutes(testNetwork, 'A');

        final routeE = routes.getRoute('E');
        final routeH = routes.getRoute('H');

        expect(routeE, isNotNull);
        expect(routeE!.isDirectlyConnected, isFalse);
        expect(routeE.cost, greaterThan(1));

        expect(routeH, isNotNull);
        expect(routeH!.isDirectlyConnected, isFalse);
        expect(routeH.cost, greaterThan(1));
      });

      test('computeRoutes respects maximum hop count', () {
        final routes = ripAlgorithm.computeRoutes(testNetwork, 'A', maxHops: 3);

        // All routes should have cost <= 3
        for (final route in routes.allRoutes) {
          expect(route.cost, lessThanOrEqualTo(3));
        }
      });

      test('updateRoutes updates routing table with new information', () {
        final currentRoutes = ripAlgorithm.computeRoutes(testNetwork, 'A');
        final now = DateTime.now();

        final advertisements = <String, RouteEntry<String>>{
          'X': RouteEntry<String>(
            destination: 'X',
            nextHop: 'B',
            cost: 2,
            lastUpdate: now,
            isDirectlyConnected: false,
          ),
        };

        final updatedRoutes = ripAlgorithm.updateRoutes(
          currentRoutes,
          advertisements,
          'B',
          1,
        );

        expect(updatedRoutes.routeCount, greaterThan(currentRoutes.routeCount));
        expect(updatedRoutes.getRoute('X'), isNotNull);
      });

      test('cleanupStaleRoutes removes old routes', () {
        final routes = ripAlgorithm.computeRoutes(testNetwork, 'A');
        final currentTime = DateTime.now();

        final cleanedRoutes = ripAlgorithm.cleanupStaleRoutes(
          routes,
          currentTime,
        );

        expect(cleanedRoutes.routeCount, lessThanOrEqualTo(routes.routeCount));
      });

      test('getRouteStatistics returns comprehensive statistics', () {
        final routes = ripAlgorithm.computeRoutes(testNetwork, 'A');
        final stats = ripAlgorithm.getRouteStatistics(routes);

        expect(stats['totalRoutes'], isNotNull);
        expect(stats['directlyConnected'], isNotNull);
        expect(stats['indirectRoutes'], isNotNull);
        expect(stats['averageCost'], isNotNull);
        expect(stats['maxCost'], isNotNull);
        expect(stats['minCost'], isNotNull);
      });

      test('validateRoutingTable returns empty list for valid table', () {
        final routes = ripAlgorithm.computeRoutes(testNetwork, 'A');
        final errors = ripAlgorithm.validateRoutingTable(routes, testNetwork);

        expect(errors, isEmpty);
      });

      test('validateRoutingTable detects invalid source node', () {
        final routes = RoutingTable<String>(
          sourceNode: 'Z',
          routes: <String, RouteEntry<String>>{},
          lastUpdate: DateTime.now(),
        );

        final errors = ripAlgorithm.validateRoutingTable(routes, testNetwork);

        expect(errors, isNotEmpty);
        expect(errors.first, contains('Source node Z not found'));
      });

      test('needsUpdate returns true when update is needed', () {
        final routes = RoutingTable<String>(
          sourceNode: 'A',
          routes: <String, RouteEntry<String>>{},
          lastUpdate: DateTime.now().subtract(Duration(seconds: 60)),
        );

        final needsUpdate = ripAlgorithm.needsUpdate(routes, DateTime.now());

        expect(needsUpdate, isTrue);
      });

      test('needsUpdate returns false when update is not needed', () {
        final routes = RoutingTable<String>(
          sourceNode: 'A',
          routes: <String, RouteEntry<String>>{},
          lastUpdate: DateTime.now().subtract(Duration(seconds: 10)),
        );

        final needsUpdate = ripAlgorithm.needsUpdate(routes, DateTime.now());

        expect(needsUpdate, isFalse);
      });
    });

    group('Convenience Function Tests', () {
      test('computeRIPRoutes works correctly', () {
        final routes = computeRIPRoutes(testNetwork, 'A');

        expect(routes.sourceNode, equals('A'));
        expect(routes.routeCount, greaterThan(0));
        expect(routes.getRoute('A'), isNotNull);
        expect(routes.getRoute('B'), isNotNull);
      });

      test('computeRIPRoutes with custom maxHops', () {
        final routes = computeRIPRoutes(testNetwork, 'A', maxHops: 2);

        for (final route in routes.allRoutes) {
          expect(route.cost, lessThanOrEqualTo(2));
        }
      });
    });

    group('Edge Cases and Error Handling', () {
      test('Handles empty network gracefully', () {
        final emptyNetwork = <String, Map<String, num>>{};
        expect(
          () => ripAlgorithm.computeRoutes(emptyNetwork, 'A'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('Handles single node network', () {
        final singleNodeNetwork = <String, Map<String, num>>{
          'A': <String, num>{},
        };
        final routes = ripAlgorithm.computeRoutes(singleNodeNetwork, 'A');

        expect(routes.routeCount, equals(1)); // Only self-route
        expect(routes.getRoute('A'), isNotNull);
      });

      test('Handles disconnected nodes', () {
        final disconnectedNetwork = <String, Map<String, num>>{
          'A': {'B': 1},
          'B': {'A': 1},
          'C': <String, num>{}, // Disconnected
        };

        final routes = ripAlgorithm.computeRoutes(disconnectedNetwork, 'A');

        expect(routes.getRoute('A'), isNotNull);
        expect(routes.getRoute('B'), isNotNull);
        expect(routes.getRoute('C'), isNull); // Should not be reachable
      });

      test('Handles negative costs gracefully', () {
        final negativeCostNetwork = <String, Map<String, num>>{
          'A': {'B': -1, 'C': 4},
          'B': {'A': -1, 'C': 2},
          'C': {'A': 4, 'B': 2},
        };

        final routes = ripAlgorithm.computeRoutes(negativeCostNetwork, 'A');

        expect(routes.routeCount, greaterThan(0));
        // Should handle negative costs appropriately
      });
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
        final routes = ripAlgorithm.computeRoutes(largeNetwork, 'Node0');
        stopwatch.stop();

        expect(routes.routeCount, greaterThan(0));
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

        final routes = ripAlgorithm.computeRoutes(complexNetwork, 'A');

        expect(routes.routeCount, equals(15)); // All nodes should be reachable
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
