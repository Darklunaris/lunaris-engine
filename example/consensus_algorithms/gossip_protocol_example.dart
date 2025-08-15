/// 🌐 Gossip Protocol Example - Demonstrating Distributed Systems Communication
///
/// This example showcases the production-ready Gossip Protocol implementation with
/// various use cases including peer-to-peer networks, distributed databases,
/// service discovery, and failure detection in large-scale systems.
///
/// Example:
/// ```bash
/// dart run example/gossip_protocol_example.dart
/// ```
library;

import 'dart:async';
import 'package:lunaris_engine/Consensus/gossip_protocol.dart';

void main() async {
  print('🌐 Gossip Protocol Examples\n');

  // Example 1: Basic Gossip Protocol Setup
  print('=== Example 1: Basic Gossip Protocol Setup ===');
  await _demonstrateBasicSetup();

  // Example 2: Multi-Node Network Simulation
  print('\n=== Example 2: Multi-Node Network Simulation ===');
  await _demonstrateMultiNodeNetwork();

  // Example 3: Failure Detection and Recovery
  print('\n=== Example 3: Failure Detection and Recovery ===');
  await _demonstrateFailureDetection();

  // Example 4: Anti-Entropy Synchronization
  print('\n=== Example 4: Anti-Entropy Synchronization ===');
  await _demonstrateAntiEntropy();

  // Example 5: Message Propagation Patterns
  print('\n=== Example 5: Message Propagation Patterns ===');
  await _demonstrateMessagePropagation();

  // Example 6: Performance and Scalability
  print('\n=== Example 6: Performance and Scalability ===');
  await _demonstratePerformance();

  // Example 7: Custom Configurations
  print('\n=== Example 7: Custom Configurations ===');
  await _demonstrateCustomConfigurations();

  print('\n✅ All Gossip Protocol examples completed successfully!');
}

/// Demonstrates basic gossip protocol setup and operation
Future<void> _demonstrateBasicSetup() async {
  print('Setting up basic gossip protocol...');

  // Create a gossip protocol instance
  final gossipProtocol = GossipProtocol<String>.create(
    nodeId: 'node1',
    address: '127.0.0.1',
    port: 8080,
    config: GossipConfig.smallNetwork(),
  );

  print('  - Gossip protocol created with ID: ${gossipProtocol.nodeId}');
  print('  - Configuration: ${gossipProtocol.config}');

  // Start the protocol
  gossipProtocol.start();
  print('  - Protocol started successfully');

  // Add some nodes to the network
  gossipProtocol.addNode('node2', '127.0.0.1', 8081);
  gossipProtocol.addNode('node3', '127.0.0.1', 8082);
  gossipProtocol.addNode('node4', '127.0.0.1', 8083);

  print('  - Added ${gossipProtocol.membership.length} nodes to network');

  // Gossip some messages
  gossipProtocol.gossip('Hello from node1!');
  gossipProtocol.gossip('System status: healthy');
  gossipProtocol.gossip('Configuration updated');

  print('  - Gossiped ${gossipProtocol.messages.length} messages');

  // Wait for gossip rounds
  await Future.delayed(Duration(milliseconds: 500));

  print('  - Current membership: ${gossipProtocol.membership.length} nodes');
  print('  - Current messages: ${gossipProtocol.messages.length}');

  // Stop the protocol
  gossipProtocol.stop();
  print('  - Protocol stopped');
}

/// Demonstrates multi-node network simulation
Future<void> _demonstrateMultiNodeNetwork() async {
  print('Simulating multi-node network...');

  // Create multiple gossip protocols
  final nodes = <String, GossipProtocol<String>>{};
  final nodeCount = 5;

  for (int i = 1; i <= nodeCount; i++) {
    final nodeId = 'node$i';
    final node = GossipProtocol<String>.create(
      nodeId: nodeId,
      address: '127.0.0.1',
      port: 8080 + i,
      config: GossipConfig.smallNetwork(),
    );

    nodes[nodeId] = node;
    node.start();
  }

  print('  - Created $nodeCount nodes');

  // Add nodes to each other's membership
  for (final entry in nodes.entries) {
    final node = entry.value;
    for (final otherEntry in nodes.entries) {
      if (otherEntry.key != entry.key) {
        node.addNode(
          otherEntry.key,
          otherEntry.value.config.gossipInterval.inMilliseconds.toString(),
          otherEntry.value.config.fanout,
        );
      }
    }
  }

  print('  - All nodes added to each other\'s membership');

  // Start gossiping from different nodes
  nodes['node1']!.gossip('Message from node1: Network initialization');
  nodes['node3']!.gossip('Message from node3: System ready');
  nodes['node5']!.gossip('Message from node5: All systems operational');

  print('  - Started gossiping from multiple nodes');

  // Wait for message propagation
  await Future.delayed(Duration(seconds: 2));

  // Check message propagation
  for (final entry in nodes.entries) {
    final nodeId = entry.key;
    final node = entry.value;

    print(
      '  - $nodeId: ${node.messages.length} messages, ${node.membership.length} members',
    );
  }

  // Stop all nodes
  for (final node in nodes.values) {
    node.stop();
  }

  print('  - All nodes stopped');
}

/// Demonstrates failure detection and recovery mechanisms
Future<void> _demonstrateFailureDetection() async {
  print('Demonstrating failure detection and recovery...');

  // Create a network with failure detection
  final network = GossipProtocol<String>.create(
    nodeId: 'coordinator',
    address: '127.0.0.1',
    port: 9000,
    config: GossipConfig(
      failureTimeout: Duration(seconds: 5),
      suspectTimeout: Duration(seconds: 2),
      gossipInterval: Duration(milliseconds: 200),
    ),
  );

  network.start();

  // Add nodes
  network.addNode('worker1', '127.0.0.1', 9001);
  network.addNode('worker2', '127.0.0.1', 9002);
  network.addNode('worker3', '127.0.0.1', 9003);

  print('  - Network created with ${network.membership.length} nodes');
  print('  - Failure timeout: ${network.config.failureTimeout.inSeconds}s');
  print('  - Suspect timeout: ${network.config.suspectTimeout.inSeconds}s');

  // Simulate normal operation
  network.gossip('System heartbeat: All workers operational');
  await Future.delayed(Duration(seconds: 1));

  print(
    '  - Normal operation: ${network.membership.where((n) => n.isAlive).length} alive nodes',
  );

  // Simulate worker2 failure (remove from membership)
  network.removeNode('worker2');
  print('  - Simulated failure of worker2');

  // Wait for failure detection
  await Future.delayed(Duration(seconds: 6));

  // Check membership status
  final aliveNodes = network.membership.where((n) => n.isAlive).toList();
  final suspectNodes = network.membership.where((n) => n.isSuspect).toList();
  final deadNodes = network.membership.where((n) => n.isDead).toList();

  print('  - After failure detection:');
  print('    • Alive nodes: ${aliveNodes.length}');
  print('    • Suspect nodes: ${suspectNodes.length}');
  print('    • Dead nodes: ${deadNodes.length}');

  // Simulate recovery
  network.addNode('worker2', '127.0.0.1', 9002);
  print('  - Simulated recovery of worker2');

  await Future.delayed(Duration(seconds: 2));

  final recoveredAliveNodes =
      network.membership.where((n) => n.isAlive).toList();
  print('  - After recovery: ${recoveredAliveNodes.length} alive nodes');

  network.stop();
}

/// Demonstrates anti-entropy synchronization
Future<void> _demonstrateAntiEntropy() async {
  print('Demonstrating anti-entropy synchronization...');

  // Create two nodes with anti-entropy enabled
  final node1 = GossipProtocol<String>.create(
    nodeId: 'sync_node1',
    address: '127.0.0.1',
    port: 10000,
    config: GossipConfig(
      enableAntiEntropy: true,
      antiEntropyInterval: Duration(seconds: 3),
      gossipInterval: Duration(milliseconds: 100),
    ),
  );

  final node2 = GossipProtocol<String>.create(
    nodeId: 'sync_node2',
    address: '127.0.0.1',
    port: 10001,
    config: GossipConfig(
      enableAntiEntropy: true,
      antiEntropyInterval: Duration(seconds: 3),
      gossipInterval: Duration(milliseconds: 100),
    ),
  );

  node1.start();
  node2.start();

  // Add nodes to each other
  node1.addNode('sync_node2', '127.0.0.1', 10001);
  node2.addNode('sync_node1', '127.0.0.1', 10000);

  print('  - Created two nodes with anti-entropy enabled');

  // Add different data to each node
  node1.gossip('Data from node1: Configuration A');
  node1.gossip('Data from node1: User preferences');

  node2.gossip('Data from node2: Configuration B');
  node2.gossip('Data from node2: System metrics');

  print('  - Added different data to each node');
  print('  - Node1 messages: ${node1.messages.length}');
  print('  - Node2 messages: ${node2.messages.length}');

  // Wait for anti-entropy synchronization
  await Future.delayed(Duration(seconds: 5));

  print('  - After anti-entropy synchronization:');
  print('    • Node1 messages: ${node1.messages.length}');
  print('    • Node2 messages: ${node2.messages.length}');

  // Check if data was synchronized
  final node1Data = node1.messages.map((m) => m.payload.toString()).toSet();
  final node2Data = node2.messages.map((m) => m.payload.toString()).toSet();

  final commonData = node1Data.intersection(node2Data);
  print('  - Common data between nodes: ${commonData.length} items');

  node1.stop();
  node2.stop();
}

/// Demonstrates message propagation patterns
Future<void> _demonstrateMessagePropagation() async {
  print('Demonstrating message propagation patterns...');

  // Create a larger network
  final networkSize = 8;
  final nodes = <String, GossipProtocol<String>>{};

  for (int i = 1; i <= networkSize; i++) {
    final nodeId = 'propagation_node$i';
    final node = GossipProtocol<String>.create(
      nodeId: nodeId,
      address: '127.0.0.1',
      port: 11000 + i,
      config: GossipConfig(
        fanout: 2,
        gossipInterval: Duration(milliseconds: 150),
      ),
    );

    nodes[nodeId] = node;
    node.start();
  }

  // Create fully connected network
  for (final entry in nodes.entries) {
    final node = entry.value;
    for (final otherEntry in nodes.entries) {
      if (otherEntry.key != entry.key) {
        node.addNode(
          otherEntry.key,
          otherEntry.value.config.gossipInterval.inMilliseconds.toString(),
          otherEntry.value.config.fanout,
        );
      }
    }
  }

  print('  - Created network with $networkSize nodes');
  print('  - Fanout: ${nodes.values.first.config.fanout}');

  // Start message propagation from a single node
  final startTime = DateTime.now();
  nodes['propagation_node1']!.gossip(
    'Important announcement: System maintenance scheduled',
  );

  print('  - Started message propagation from propagation_node1');

  // Monitor propagation
  int rounds = 0;
  final maxRounds = 10;

  while (rounds < maxRounds) {
    await Future.delayed(Duration(milliseconds: 300));
    rounds++;

    final messageCounts = <String, int>{};
    for (final entry in nodes.entries) {
      messageCounts[entry.key] = entry.value.messages.length;
    }

    final totalMessages = messageCounts.values.reduce((a, b) => a + b);
    final averageMessages = totalMessages / networkSize;

    print(
      '  - Round $rounds: Average messages per node: ${averageMessages.toStringAsFixed(1)}',
    );

    // Check if message has propagated to all nodes
    final allNodesHaveMessage = messageCounts.values.every(
      (count) => count > 0,
    );
    if (allNodesHaveMessage) {
      print('  - Message has propagated to all nodes in $rounds rounds');
      break;
    }
  }

  final propagationTime = DateTime.now().difference(startTime);
  print('  - Total propagation time: ${propagationTime.inMilliseconds}ms');

  // Stop all nodes
  for (final node in nodes.values) {
    node.stop();
  }
}

/// Demonstrates performance and scalability characteristics
Future<void> _demonstratePerformance() async {
  print('Analyzing performance and scalability...');

  // Test different network sizes
  final networkSizes = [5, 10, 20, 50];

  for (final size in networkSizes) {
    print('  - Testing network size: $size nodes');

    final startTime = DateTime.now();

    // Create network
    final nodes = <String, GossipProtocol<String>>{};

    for (int i = 1; i <= size; i++) {
      final nodeId = 'perf_node$i';
      final node = GossipProtocol<String>.create(
        nodeId: nodeId,
        address: '127.0.0.1',
        port: 12000 + i,
        config: GossipConfig.smallNetwork(),
      );

      nodes[nodeId] = node;
      node.start();
    }

    final creationTime = DateTime.now().difference(startTime);

    // Add nodes to each other
    final membershipStartTime = DateTime.now();
    for (final entry in nodes.entries) {
      final node = entry.value;
      for (final otherEntry in nodes.entries) {
        if (otherEntry.key != entry.key) {
          node.addNode(
            otherEntry.key,
            otherEntry.value.config.gossipInterval.inMilliseconds.toString(),
            otherEntry.value.config.fanout,
          );
        }
      }
    }
    final membershipTime = DateTime.now().difference(membershipStartTime);

    // Test message propagation
    final propagationStartTime = DateTime.now();
    nodes['perf_node1']!.gossip(
      'Performance test message for network size $size',
    );

    // Wait for propagation
    await Future.delayed(Duration(milliseconds: 500));
    final propagationTime = DateTime.now().difference(propagationStartTime);

    // Calculate metrics
    final totalMessages = nodes.values
        .map((n) => n.messages.length)
        .reduce((a, b) => a + b);
    final averageMessages = totalMessages / size;

    print('    • Creation time: ${creationTime.inMilliseconds}ms');
    print('    • Membership setup: ${membershipTime.inMilliseconds}ms');
    print('    • Message propagation: ${propagationTime.inMilliseconds}ms');
    print(
      '    • Average messages per node: ${averageMessages.toStringAsFixed(1)}',
    );

    // Stop all nodes
    for (final node in nodes.values) {
      node.stop();
    }
  }

  // Test different configurations
  print('  - Testing different configurations:');

  final configs = [
    {'name': 'Small Network', 'config': GossipConfig.smallNetwork()},
    {'name': 'Large Network', 'config': GossipConfig.largeNetwork()},
    {
      'name': 'Custom Fast',
      'config': GossipConfig(
        gossipInterval: Duration(milliseconds: 50),
        fanout: 4,
        failureTimeout: Duration(seconds: 10),
      ),
    },
  ];

  for (final configInfo in configs) {
    final name = configInfo['name'] as String;
    final config = configInfo['config'] as GossipConfig;

    final startTime = DateTime.now();
    final node = GossipProtocol<String>.create(
      nodeId: 'config_test',
      address: '127.0.0.1',
      port: 13000,
      config: config,
    );

    node.start();
    final creationTime = DateTime.now().difference(startTime);

    // Add test nodes
    for (int i = 1; i <= 5; i++) {
      node.addNode('test$i', '127.0.0.1', 13000 + i);
    }

    // Test message throughput
    final messageStartTime = DateTime.now();
    for (int i = 0; i < 100; i++) {
      node.gossip('Test message $i');
    }
    final messageTime = DateTime.now().difference(messageStartTime);

    print('    • $name:');
    print('      - Creation: ${creationTime.inMicroseconds}μs');
    print('      - 100 messages: ${messageTime.inMilliseconds}ms');
    print(
      '      - Throughput: ${(100 / messageTime.inMilliseconds * 1000).toStringAsFixed(0)} msg/s',
    );

    node.stop();
  }
}

/// Demonstrates custom configurations and advanced features
Future<void> _demonstrateCustomConfigurations() async {
  print('Demonstrating custom configurations...');

  // Custom configuration for high-performance scenario
  final highPerfConfig = GossipConfig(
    gossipInterval: Duration(milliseconds: 25),
    fanout: 6,
    failureTimeout: Duration(seconds: 5),
    suspectTimeout: Duration(seconds: 2),
    maxMessageSize: 1024 * 1024 * 10, // 10MB
    maxMembershipSize: 10000,
    enableAntiEntropy: true,
    antiEntropyInterval: Duration(seconds: 30),
  );

  final highPerfNode = GossipProtocol<String>.create(
    nodeId: 'high_perf_node',
    address: '127.0.0.1',
    port: 14000,
    config: highPerfConfig,
  );

  print('  - High-performance configuration:');
  print(
    '    • Gossip interval: ${highPerfConfig.gossipInterval.inMilliseconds}ms',
  );
  print('    • Fanout: ${highPerfConfig.fanout}');
  print(
    '    • Max message size: ${highPerfConfig.maxMessageSize ~/ (1024 * 1024)}MB',
  );
  print('    • Anti-entropy: ${highPerfConfig.enableAntiEntropy}');

  highPerfNode.start();

  // Test message streaming
  final streamSubscription = highPerfNode.messageStream.listen((message) {
    print(
      '    • Received message: ${message.type.name} from ${message.sourceNodeId}',
    );
  });

  final membershipSubscription = highPerfNode.membershipStream.listen((node) {
    print('    • Membership update: ${node.nodeId} is ${node.state.name}');
  });

  // Add nodes and send messages
  highPerfNode.addNode('stream_node1', '127.0.0.1', 14001);
  highPerfNode.addNode('stream_node2', '127.0.0.1', 14002);

  highPerfNode.gossip('Stream test message 1');
  highPerfNode.gossip(
    'Stream test message 2',
    type: GossipMessageType.heartbeat,
  );

  await Future.delayed(Duration(milliseconds: 500));

  // Test serialization
  final json = highPerfNode.toJson();
  print('  - Serialization test:');
  print('    • JSON keys: ${json.keys.toList()}');
  print('    • Node count: ${json['membership']?.length ?? 0}');
  print('    • Message count: ${json['messageCount'] ?? 0}');

  // Cleanup
  await streamSubscription.cancel();
  await membershipSubscription.cancel();
  highPerfNode.stop();

  print('  - Custom configuration test completed');
}
