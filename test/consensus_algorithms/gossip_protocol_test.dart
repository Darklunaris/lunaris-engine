import 'package:lunaris_engine/Consensus/gossip_protocol.dart';
import 'package:test/test.dart';
import 'dart:async';

void main() {
  group('GossipProtocol Tests', () {
    group('Basic Operations', () {
      test('Protocol creation', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'test_node',
          address: '127.0.0.1',
          port: 8080,
        );

        expect(protocol.nodeId, equals('test_node'));
        expect(protocol.membership.length, equals(1)); // Self
        expect(protocol.messages.length, equals(0));
      });

      test('Protocol with custom configuration', () {
        final config = GossipConfig(
          gossipInterval: Duration(milliseconds: 50),
          fanout: 5,
          failureTimeout: Duration(seconds: 10),
        );

        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'custom_node',
          address: '127.0.0.1',
          port: 8081,
          config: config,
        );

        expect(
          protocol.config.gossipInterval,
          equals(Duration(milliseconds: 50)),
        );
        expect(protocol.config.fanout, equals(5));
        expect(protocol.config.failureTimeout, equals(Duration(seconds: 10)));
      });

      test('Protocol start and stop', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'start_stop_node',
          address: '127.0.0.1',
          port: 8082,
        );

        protocol.start();
        expect(protocol.membership.length, equals(1));

        protocol.stop();
        // After stop, we can't verify much, but it shouldn't throw
      });
    });

    group('Node Management', () {
      test('Add node to membership', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'manager_node',
          address: '127.0.0.1',
          port: 8083,
        );

        protocol.addNode('worker1', '127.0.0.1', 8084);

        expect(protocol.membership.length, equals(2));
        expect(protocol.membership.any((n) => n.nodeId == 'worker1'), isTrue);
      });

      test('Remove node from membership', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'manager_node',
          address: '127.0.0.1',
          port: 8085,
        );

        protocol.addNode('worker1', '127.0.0.1', 8086);
        expect(protocol.membership.length, equals(2));

        protocol.removeNode('worker1');
        expect(protocol.membership.length, equals(1));
        expect(protocol.membership.any((n) => n.nodeId == 'worker1'), isFalse);
      });

      test('Cannot remove self', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'self_node',
          address: '127.0.0.1',
          port: 8087,
        );

        protocol.removeNode('self_node');
        expect(
          protocol.membership.length,
          equals(1),
        ); // Self should still be there
      });

      test('Node state properties', () {
        final node = GossipNode<String>(
          nodeId: 'test_node',
          address: '127.0.0.1',
          port: 8088,
          lastSeen: DateTime.now(),
          state: GossipNodeState.alive,
        );

        expect(node.isAlive, isTrue);
        expect(node.isSuspect, isFalse);
        expect(node.isDead, isFalse);

        final suspectNode = node.copyWith(state: GossipNodeState.suspect);
        expect(suspectNode.isSuspect, isTrue);

        final deadNode = node.copyWith(state: GossipNodeState.dead);
        expect(deadNode.isDead, isTrue);
      });
    });

    group('Message Handling', () {
      test('Gossip message creation', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'message_node',
          address: '127.0.0.1',
          port: 8089,
        );

        protocol.gossip('Hello, distributed world!');

        expect(protocol.messages.length, equals(1));
        expect(
          protocol.messages.first.payload,
          equals('Hello, distributed world!'),
        );
        expect(protocol.messages.first.sourceNodeId, equals('message_node'));
        expect(protocol.messages.first.type, equals(GossipMessageType.data));
      });

      test('Message with custom type', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'type_node',
          address: '127.0.0.1',
          port: 8090,
        );

        protocol.gossip('Heartbeat message', type: GossipMessageType.heartbeat);

        expect(protocol.messages.length, equals(1));
        expect(
          protocol.messages.first.type,
          equals(GossipMessageType.heartbeat),
        );
      });

      test('Message TTL and expiration', () {
        final message = GossipMessage(
          messageId: 'test_msg',
          sourceNodeId: 'test_node',
          payload: 'test_payload',
          timestamp: DateTime.now(),
          ttl: 3,
          type: GossipMessageType.data,
        );

        expect(message.isExpired, isFalse);

        final expiredMessage = message.copyWithDecrementedTtl();
        expect(expiredMessage.ttl, equals(2));

        final zeroTTLMessage = GossipMessage(
          messageId: 'expired',
          sourceNodeId: 'test',
          payload: 'test',
          timestamp: DateTime.now(),
          ttl: 0,
          type: GossipMessageType.data,
        );

        expect(zeroTTLMessage.isExpired, isTrue);
      });

      test('Message serialization', () {
        final message = GossipMessage(
          messageId: 'serialize_test',
          sourceNodeId: 'test_node',
          payload: 'test_payload',
          timestamp: DateTime.now(),
          ttl: 5,
          type: GossipMessageType.data,
          metadata: {'key': 'value'},
        );

        final json = message.toJson();

        expect(json['messageId'], equals('serialize_test'));
        expect(json['sourceNodeId'], equals('test_node'));
        expect(json['payload'], equals('test_payload'));
        expect(json['ttl'], equals(5));
        expect(json['type'], equals('data'));
        expect(json['metadata'], isMap);
      });

      test('Message deserialization', () {
        final originalMessage = GossipMessage(
          messageId: 'deserialize_test',
          sourceNodeId: 'test_node',
          payload: 'test_payload',
          timestamp: DateTime.now(),
          ttl: 3,
          type: GossipMessageType.heartbeat,
        );

        final json = originalMessage.toJson();
        final reconstructedMessage = GossipMessage.fromJson(json);

        expect(
          reconstructedMessage.messageId,
          equals(originalMessage.messageId),
        );
        expect(
          reconstructedMessage.sourceNodeId,
          equals(originalMessage.sourceNodeId),
        );
        expect(reconstructedMessage.ttl, equals(originalMessage.ttl));
        expect(reconstructedMessage.type, equals(originalMessage.type));
      });
    });

    group('Configuration', () {
      test('Default configuration', () {
        final config = GossipConfig();

        expect(config.gossipInterval, equals(Duration(milliseconds: 100)));
        expect(config.fanout, equals(3));
        expect(config.failureTimeout, equals(Duration(seconds: 30)));
        expect(config.suspectTimeout, equals(Duration(seconds: 10)));
        expect(config.maxMessageSize, equals(1024 * 1024));
        expect(config.maxMembershipSize, equals(1000));
        expect(config.enableAntiEntropy, isTrue);
        expect(config.antiEntropyInterval, equals(Duration(seconds: 60)));
      });

      test('Small network configuration', () {
        final config = GossipConfig.smallNetwork();

        expect(config.gossipInterval.inMilliseconds, equals(50));
        expect(config.fanout, equals(2));
        expect(config.failureTimeout.inSeconds, equals(15));
        expect(config.suspectTimeout.inSeconds, equals(5));
        expect(config.maxMembershipSize, equals(100));
        expect(config.antiEntropyInterval.inSeconds, equals(30));
      });

      test('Large network configuration', () {
        final config = GossipConfig.largeNetwork();

        expect(config.gossipInterval.inMilliseconds, equals(200));
        expect(config.fanout, equals(5));
        expect(config.failureTimeout.inMinutes, equals(2));
        expect(config.suspectTimeout.inSeconds, equals(30));
        expect(config.maxMembershipSize, equals(10000));
        expect(config.antiEntropyInterval.inMinutes, equals(5));
      });

      test('Configuration string representation', () {
        final config = GossipConfig(
          gossipInterval: Duration(milliseconds: 150),
          fanout: 4,
          failureTimeout: Duration(seconds: 45),
        );

        final str = config.toString();
        expect(str, contains('150'));
        expect(str, contains('4'));
        expect(str, contains('45'));
      });
    });

    group('GossipNode', () {
      test('Node creation and properties', () {
        final now = DateTime.now();
        final node = GossipNode<String>(
          nodeId: 'test_node',
          address: '192.168.1.100',
          port: 9090,
          lastSeen: now,
          state: GossipNodeState.alive,
          metadata: {'version': '1.0.0'},
        );

        expect(node.nodeId, equals('test_node'));
        expect(node.address, equals('192.168.1.100'));
        expect(node.port, equals(9090));
        expect(node.lastSeen, equals(now));
        expect(node.state, equals(GossipNodeState.alive));
        expect(node.metadata['version'], equals('1.0.0'));
      });

      test('Node copyWith', () {
        final originalNode = GossipNode<String>(
          nodeId: 'original',
          address: '127.0.0.1',
          port: 8080,
          lastSeen: DateTime.now(),
          state: GossipNodeState.alive,
        );

        final updatedNode = originalNode.copyWith(
          state: GossipNodeState.suspect,
          metadata: {'updated': true},
        );

        expect(updatedNode.nodeId, equals('original'));
        expect(updatedNode.state, equals(GossipNodeState.suspect));
        expect(updatedNode.metadata['updated'], isTrue);
        expect(updatedNode.address, equals(originalNode.address));
        expect(updatedNode.port, equals(originalNode.port));
      });

      test('Node equality and hashCode', () {
        final node1 = GossipNode<String>(
          nodeId: 'same_id',
          address: '127.0.0.1',
          port: 8080,
          lastSeen: DateTime.now(),
          state: GossipNodeState.alive,
        );

        final node2 = GossipNode<String>(
          nodeId: 'same_id',
          address: '192.168.1.1',
          port: 9090,
          lastSeen: DateTime.now().add(Duration(hours: 1)),
          state: GossipNodeState.dead,
        );

        expect(node1, equals(node2));
        expect(node1.hashCode, equals(node2.hashCode));

        final node3 = GossipNode<String>(
          nodeId: 'different_id',
          address: '127.0.0.1',
          port: 8080,
          lastSeen: DateTime.now(),
          state: GossipNodeState.alive,
        );

        expect(node1, isNot(equals(node3)));
      });

      test('Node JSON serialization', () {
        final node = GossipNode<String>(
          nodeId: 'json_node',
          address: '127.0.0.1',
          port: 8080,
          lastSeen: DateTime(2024, 1, 1, 12, 0, 0),
          state: GossipNodeState.alive,
          metadata: {'test': 'value'},
        );

        final json = node.toJson();

        expect(json['nodeId'], equals('json_node'));
        expect(json['address'], equals('127.0.0.1'));
        expect(json['port'], equals(8080));
        expect(json['state'], equals('alive'));
        expect(json['metadata'], isMap);
        expect(json['metadata']['test'], equals('value'));
      });

      test('Node JSON deserialization', () {
        final json = {
          'nodeId': 'deserialize_node',
          'address': '127.0.0.1',
          'port': 8080,
          'lastSeen': '2024-01-01T12:00:00.000Z',
          'state': 'alive',
          'metadata': {'test': 'value'},
        };

        final node = GossipNode<String>.fromJson(json);

        expect(node.nodeId, equals('deserialize_node'));
        expect(node.address, equals('127.0.0.1'));
        expect(node.port, equals(8080));
        expect(node.state, equals(GossipNodeState.alive));
        expect(node.metadata['test'], equals('value'));
      });

      test('Node string representation', () {
        final node = GossipNode<String>(
          nodeId: 'string_test_node',
          address: '127.0.0.1',
          port: 8080,
          lastSeen: DateTime.now(),
          state: GossipNodeState.alive,
        );

        final str = node.toString();
        expect(str, contains('string_test_node'));
        expect(str, contains('127.0.0.1:8080'));
        expect(str, contains('alive'));
      });
    });

    group('Message Types', () {
      test('Message type enum values', () {
        expect(GossipMessageType.data.name, equals('data'));
        expect(GossipMessageType.membership.name, equals('membership'));
        expect(GossipMessageType.heartbeat.name, equals('heartbeat'));
        expect(GossipMessageType.antiEntropy.name, equals('antiEntropy'));
        expect(GossipMessageType.failure.name, equals('failure'));
      });

      test('Message type from JSON', () {
        final json = {'type': 'heartbeat'};
        final message = GossipMessage.fromJson(json);
        expect(message.type, equals(GossipMessageType.heartbeat));
      });

      test('Unknown message type defaults to data', () {
        final json = {'type': 'unknown_type'};
        final message = GossipMessage.fromJson(json);
        expect(message.type, equals(GossipMessageType.data));
      });
    });

    group('Node States', () {
      test('Node state enum values', () {
        expect(GossipNodeState.alive.name, equals('alive'));
        expect(GossipNodeState.suspect.name, equals('suspect'));
        expect(GossipNodeState.dead.name, equals('dead'));
      });

      test('Node state from JSON', () {
        final json = {'state': 'suspect'};
        final node = GossipNode<String>.fromJson(json);
        expect(node.state, equals(GossipNodeState.suspect));
      });

      test('Unknown node state defaults to alive', () {
        final json = {'state': 'unknown_state'};
        final node = GossipNode<String>.fromJson(json);
        expect(node.state, equals(GossipNodeState.alive));
      });
    });

    group('Streams and Events', () {
      test('Message stream subscription', () async {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'stream_node',
          address: '127.0.0.1',
          port: 8091,
        );

        protocol.start();

        final messages = <GossipMessage>[];
        final subscription = protocol.messageStream.listen(messages.add);

        protocol.gossip('Test message for stream');

        await Future.delayed(Duration(milliseconds: 100));

        expect(messages.length, greaterThan(0));

        await subscription.cancel();
        protocol.stop();
      });

      test('Membership stream subscription', () async {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'membership_stream_node',
          address: '127.0.0.1',
          port: 8092,
        );

        protocol.start();

        final nodes = <GossipNode<String>>[];
        final subscription = protocol.membershipStream.listen(nodes.add);

        protocol.addNode('worker1', '127.0.0.1', 8093);

        await Future.delayed(Duration(milliseconds: 100));

        expect(nodes.length, greaterThan(0));

        await subscription.cancel();
        protocol.stop();
      });
    });

    group('Serialization', () {
      test('Protocol to JSON', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'json_protocol',
          address: '127.0.0.1',
          port: 8094,
        );

        protocol.addNode('worker1', '127.0.0.1', 8095);
        protocol.gossip('Test message');

        final json = protocol.toJson();

        expect(json['nodeId'], equals('json_protocol'));
        expect(json['config'], isMap);
        expect(json['membership'], isList);
        expect(json['messageCount'], isA<int>());

        final config = json['config'] as Map<String, dynamic>;
        expect(config['gossipInterval'], isA<int>());
        expect(config['fanout'], isA<int>());
        expect(config['failureTimeout'], isA<int>());
      });

      test('Protocol string representation', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'string_protocol',
          address: '127.0.0.1',
          port: 8096,
        );

        protocol.addNode('worker1', '127.0.0.1', 8097);
        protocol.gossip('Test message');

        final str = protocol.toString();
        expect(str, contains('string_protocol'));
        expect(str, contains('1')); // 1 member (self)
        expect(str, contains('1')); // 1 message
      });
    });

    group('Edge Cases', () {
      test('Empty membership handling', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'empty_node',
          address: '127.0.0.1',
          port: 8098,
        );

        expect(protocol.membership.length, equals(1)); // Self
        expect(protocol.messages.length, equals(0));
      });

      test('Large message handling', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'large_message_node',
          address: '127.0.0.1',
          port: 8099,
        );

        final largeMessage = 'x' * 10000;
        protocol.gossip(largeMessage);

        expect(protocol.messages.length, equals(1));
        expect(protocol.messages.first.payload, equals(largeMessage));
      });

      test('Special characters in node ID', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'special_chars_test',
          address: '127.0.0.1',
          port: 8100,
        );

        expect(protocol.nodeId, equals('special_chars_test'));
        expect(protocol.membership.length, equals(1));
      });

      test('High port numbers', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'high_port_node',
          address: '127.0.0.1',
          port: 65535,
        );

        expect(protocol.membership.first.port, equals(65535));
      });
    });

    group('Performance Tests', () {
      test('Large membership performance', () {
        final startTime = DateTime.now();

        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'perf_node',
          address: '127.0.0.1',
          port: 8101,
        );

        // Add many nodes
        for (int i = 0; i < 1000; i++) {
          protocol.addNode('worker$i', '127.0.0.1', 8102 + i);
        }

        final addTime = DateTime.now().difference(startTime);
        expect(
          addTime.inMilliseconds,
          lessThan(1000),
        ); // Should be reasonably fast

        expect(protocol.membership.length, equals(1001)); // Self + 1000 workers
      });

      test('Message throughput performance', () {
        final protocol = GossipProtocol<String>.create(
          isTestMode: true,
          nodeId: 'throughput_node',
          address: '127.0.0.1',
          port: 8103,
        );

        final startTime = DateTime.now();

        // Send many messages
        for (int i = 0; i < 1000; i++) {
          protocol.gossip('Message $i');
        }

        final messageTime = DateTime.now().difference(startTime);
        expect(messageTime.inMilliseconds, lessThan(1000)); // Should be fast

        expect(protocol.messages.length, equals(1000));
      });
    });
  });
}
