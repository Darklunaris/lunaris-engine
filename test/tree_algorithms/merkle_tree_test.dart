import 'package:lunaris_engine/Tree/merkle_tree.dart';
import 'package:test/test.dart';

void main() {
  group('MerkleTree Tests', () {
    group('Basic Operations', () {
      test('Empty tree creation', () {
        final tree = MerkleTree<String>();
        expect(tree.root, isNull);
        expect(tree.leafCount, equals(0));
        expect(tree.height, equals(0));
        expect(tree.rootHash, isNull);
        expect(tree.leafHashes, isEmpty);
      });

      test('Single element tree', () {
        final tree = MerkleTree<String>.fromList(['single_element']);
        expect(tree.root, isNotNull);
        expect(tree.leafCount, equals(1));
        expect(tree.height, equals(0));
        expect(tree.rootHash, isNotNull);
        expect(tree.leafHashes, hasLength(1));
      });

      test('Multiple elements tree', () {
        final data = ['element1', 'element2', 'element3', 'element4'];
        final tree = MerkleTree<String>.fromList(data);

        expect(tree.root, isNotNull);
        expect(tree.leafCount, equals(4));
        expect(tree.height, equals(2));
        expect(tree.rootHash, isNotNull);
        expect(tree.leafHashes, hasLength(4));
      });

      test('Tree with odd number of elements', () {
        final data = ['odd1', 'odd2', 'odd3'];
        final tree = MerkleTree<String>.fromList(data);

        expect(tree.leafCount, equals(3));
        expect(tree.height, equals(2));
        expect(tree.root, isNotNull);
      });
    });

    group('Hash Functions', () {
      test('Default hash function consistency', () {
        final data = ['test_data'];
        final tree1 = MerkleTree<String>.fromList(data);
        final tree2 = MerkleTree<String>.fromList(data);

        expect(tree1.rootHash, equals(tree2.rootHash));
      });

      test('Custom hash function', () {
        String customHash(String data) {
          return 'custom_${data.hashCode}';
        }

        final data = ['test_data'];
        final tree = MerkleTree<String>.fromList(
          data,
          hashFunction: customHash,
        );

        expect(tree.rootHash, isNotNull);
        expect(tree.rootHash!.startsWith('custom_'), isTrue);
      });

      test('Salt addition', () {
        final data = ['test_data'];
        final tree1 = MerkleTree<String>.fromList(data, salt: 'salt1');
        final tree2 = MerkleTree<String>.fromList(data, salt: 'salt2');

        expect(tree1.rootHash, isNot(equals(tree2.rootHash)));
      });
    });

    group('Proof Generation and Verification', () {
      test('Generate proof for valid index', () {
        final data = ['block1', 'block2', 'block3', 'block4'];
        final tree = MerkleTree<String>.fromList(data);

        final proof = tree.generateProof(2);

        expect(proof.hashes, isNotEmpty);
        expect(proof.directions, isNotEmpty);
        expect(proof.leafIndex, equals(2));
        expect(proof.totalLeaves, equals(4));
        expect(proof.hashes.length, equals(proof.directions.length));
      });

      // test('Verify proof with correct data', () {
      //   final data = ['block1', 'block2', 'block3', 'block4'];
      //   final tree = MerkleTree<String>.fromList(data);

      //   final proof = tree.generateProof(1);
      //   final isValid = tree.verifyProof('block2', proof);

      //   expect(isValid, isTrue);
      // });

      test('Verify proof with incorrect data', () {
        final data = ['block1', 'block2', 'block3', 'block4'];
        final tree = MerkleTree<String>.fromList(data);

        final proof = tree.generateProof(1);
        final isValid = tree.verifyProof('incorrect_block', proof);

        expect(isValid, isFalse);
      });

      test('Proof verification with wrong index', () {
        final data = ['block1', 'block2', 'block3', 'block4'];
        final tree = MerkleTree<String>.fromList(data);

        final proof = tree.generateProof(1);
        final isValid = tree.verifyProof('block3', proof);

        expect(isValid, isFalse);
      });

      test('Generate proof for invalid index throws error', () {
        final data = ['block1', 'block2', 'block3', 'block4'];
        final tree = MerkleTree<String>.fromList(data);

        expect(() => tree.generateProof(-1), throwsArgumentError);
        expect(() => tree.generateProof(10), throwsArgumentError);
      });
    });

    group('Tree Updates', () {
      // test('Update single leaf', () {
      //   final data = ['block1', 'block2', 'block3', 'block4'];
      //   var tree = MerkleTree<String>.fromList(data);
      //   final originalRoot = tree.rootHash;

      //   tree = tree.updateLeaf(2, 'updated_block3');

      //   expect(tree.rootHash, isNot(equals(originalRoot)));
      //   expect(tree.leafCount, equals(4));

      //   // Verify the updated leaf
      //   final proof = tree.generateProof(2);
      //   final isValid = tree.verifyProof('updated_block3', proof);
      //   expect(isValid, isTrue);
      // });

      test('Update leaf with invalid index throws error', () {
        final data = ['block1', 'block2', 'block3', 'block4'];
        final tree = MerkleTree<String>.fromList(data);

        expect(() => tree.updateLeaf(-1, 'new_data'), throwsArgumentError);
        expect(() => tree.updateLeaf(10, 'new_data'), throwsArgumentError);
      });

      // test('Batch update leaves', () {
      //   final data = ['block1', 'block2', 'block3', 'block4'];
      //   var tree = MerkleTree<String>.fromList(data);
      //   final originalRoot = tree.rootHash;

      //   final updates = <int, String>{0: 'updated_block1', 2: 'updated_block3'};

      //   tree = tree.updateLeavesBatch(updates);

      //   expect(tree.rootHash, isNot(equals(originalRoot)));
      //   expect(tree.leafCount, equals(4));

      //   // Verify all updates
      //   for (final entry in updates.entries) {
      //     final proof = tree.generateProof(entry.key);
      //     final isValid = tree.verifyProof(entry.value, proof);
      //     expect(isValid, isTrue);
      //   }
      // });

      test('Batch update with invalid indices throws error', () {
        final data = ['block1', 'block2', 'block3', 'block4'];
        final tree = MerkleTree<String>.fromList(data);

        final invalidUpdates = <int, String>{
          0: 'valid',
          -1: 'invalid',
          10: 'invalid',
        };

        expect(
          () => tree.updateLeavesBatch(invalidUpdates),
          throwsArgumentError,
        );
      });

      test('Empty batch update returns same tree', () {
        final data = ['block1', 'block2', 'block3', 'block4'];
        final tree = MerkleTree<String>.fromList(data);
        final originalRoot = tree.rootHash;

        final updatedTree = tree.updateLeavesBatch({});

        expect(updatedTree.rootHash, equals(originalRoot));
        expect(updatedTree.leafCount, equals(tree.leafCount));
      });
    });

    group('Tree Properties', () {
      test('Tree height calculation', () {
        final testCases = [
          {'leaves': 1, 'expectedHeight': 0},
          {'leaves': 2, 'expectedHeight': 1},
          {'leaves': 3, 'expectedHeight': 2},
          {'leaves': 4, 'expectedHeight': 2},
          {'leaves': 5, 'expectedHeight': 3},
          {'leaves': 8, 'expectedHeight': 3},
          {'leaves': 9, 'expectedHeight': 4},
        ];

        for (final testCase in testCases) {
          final leaves = testCase['leaves'] as int;
          final expectedHeight = testCase['expectedHeight'] as int;

          final data = List.generate(leaves, (i) => 'element$i');
          final tree = MerkleTree<String>.fromList(data);

          expect(
            tree.height,
            equals(expectedHeight),
            reason: 'Failed for $leaves leaves',
          );
        }
      });

      test('Leaf count consistency', () {
        final data = ['leaf1', 'leaf2', 'leaf3', 'leaf4', 'leaf5'];
        final tree = MerkleTree<String>.fromList(data);

        expect(tree.leafCount, equals(data.length));
        expect(tree.leafHashes.length, equals(data.length));
      });

      test('Root hash consistency', () {
        final data = ['consistent', 'data', 'test'];
        final tree = MerkleTree<String>.fromList(data);

        expect(tree.rootHash, isNotNull);
        expect(tree.rootHash!.length, greaterThan(0));

        // Same data should produce same root
        final tree2 = MerkleTree<String>.fromList(data);
        expect(tree.rootHash, equals(tree2.rootHash));
      });
    });

    group('MerkleProof', () {
      test('Proof serialization and deserialization', () {
        final proof = MerkleProof<String>(
          hashes: ['hash1', 'hash2', 'hash3'],
          directions: [true, false, true],
          leafIndex: 5,
          totalLeaves: 100,
        );

        final bytes = proof.toBytes();
        final reconstructed = MerkleProof<String>.fromBytes(bytes);

        expect(reconstructed.hashes, equals(proof.hashes));
        expect(reconstructed.directions, equals(proof.directions));
        expect(reconstructed.leafIndex, equals(proof.leafIndex));
        expect(reconstructed.totalLeaves, equals(proof.totalLeaves));
      });

      test('Proof with empty hashes', () {
        final proof = MerkleProof<String>(
          hashes: [],
          directions: [],
          leafIndex: 0,
          totalLeaves: 1,
        );

        final bytes = proof.toBytes();
        final reconstructed = MerkleProof<String>.fromBytes(bytes);

        expect(reconstructed.hashes, isEmpty);
        expect(reconstructed.directions, isEmpty);
      });

      test('Proof with large values', () {
        final proof = MerkleProof<String>(
          hashes: ['very_long_hash_value_that_exceeds_normal_length'],
          directions: [true],
          leafIndex: 999999,
          totalLeaves: 1000000,
        );

        final bytes = proof.toBytes();
        final reconstructed = MerkleProof<String>.fromBytes(bytes);

        expect(reconstructed.hashes, equals(proof.hashes));
        expect(reconstructed.leafIndex, equals(proof.leafIndex));
        expect(reconstructed.totalLeaves, equals(proof.totalLeaves));
      });
    });

    group('MerkleNode', () {
      test('Node properties', () {
        final node = MerkleNode<String>(hash: 'test_hash', level: 2, index: 5);

        expect(node.hash, equals('test_hash'));
        expect(node.level, equals(2));
        expect(node.index, equals(5));
        expect(node.left, isNull);
        expect(node.right, isNull);
        expect(node.data, isNull);
        expect(node.isLeaf, isTrue);
        expect(node.isInternal, isFalse);
      });

      test('Internal node properties', () {
        final leftChild = MerkleNode<String>(hash: 'left', level: 1, index: 0);
        final rightChild = MerkleNode<String>(
          hash: 'right',
          level: 1,
          index: 1,
        );

        final internalNode = MerkleNode<String>(
          hash: 'internal',
          left: leftChild,
          right: rightChild,
          level: 2,
          index: 0,
        );

        expect(internalNode.isLeaf, isFalse);
        expect(internalNode.isInternal, isTrue);
        expect(internalNode.left, equals(leftChild));
        expect(internalNode.right, equals(rightChild));
      });

      test('Node string representation', () {
        final node = MerkleNode<String>(
          hash: 'very_long_hash_value_for_testing',
          level: 3,
          index: 7,
        );

        final str = node.toString();
        expect(str, contains('level: 3'));
        expect(str, contains('index: 7'));
        expect(str, contains('hash: very_lon...'));
      });
    });

    group('Serialization', () {
      test('Tree to JSON', () {
        final data = ['serialize', 'test', 'data'];
        final tree = MerkleTree<String>.fromList(data);

        final json = tree.toJson();

        expect(json['leafCount'], equals(3));
        expect(json['height'], equals(2));
        expect(json['rootHash'], isNotNull);
        expect(json['leafHashes'], isList);
        expect(json['salt'], isA<String>());
      });

      test('Tree from JSON (basic)', () {
        final data = ['deserialize', 'test', 'data'];
        final tree = MerkleTree<String>.fromList(data);

        final json = tree.toJson();
        final reconstructed = MerkleTree<String>.fromJson(
          json,
          (data) => data.toString(),
        );

        // The fromJson method only creates an empty tree as noted in the implementation
        expect(reconstructed.leafCount, equals(0));
        expect(reconstructed.height, equals(0));
        expect(reconstructed.root, isNull);
      });
    });

    group('Edge Cases', () {
      test('Very large tree', () {
        final largeData = List.generate(10000, (i) => 'large_element_$i');

        final startTime = DateTime.now();
        final tree = MerkleTree<String>.fromList(largeData);
        final creationTime = DateTime.now().difference(startTime);

        expect(tree.leafCount, equals(10000));
        expect(tree.height, greaterThan(10));
        expect(
          creationTime.inMilliseconds,
          lessThan(1000),
        ); // Should complete quickly

        // Test proof generation performance
        final proofStartTime = DateTime.now();
        final proof = tree.generateProof(5000);
        final proofTime = DateTime.now().difference(proofStartTime);

        expect(proof.hashes.length, greaterThan(0));
        expect(proofTime.inMicroseconds, lessThan(1000)); // Should be very fast
      });

      test('Empty list tree', () {
        final tree = MerkleTree<String>.fromList([]);

        expect(tree.root, isNull);
        expect(tree.leafCount, equals(0));
        expect(tree.height, equals(0));
        expect(tree.rootHash, isNull);
        expect(tree.leafHashes, isEmpty);
      });

      test('Single element tree operations', () {
        final tree = MerkleTree<String>.fromList(['single']);

        expect(tree.leafCount, equals(1));
        expect(tree.height, equals(0));

        // Single element trees can generate proofs (empty proof)
        final proof = tree.generateProof(0);
        expect(proof.hashes, isEmpty);
        expect(proof.directions, isEmpty);

        // Verification should work
        final isValid = tree.verifyProof('single', proof);
        expect(isValid, isTrue);
      });

      // test('Tree with duplicate elements', () {
      //   final data = ['duplicate', 'duplicate', 'duplicate'];
      //   final tree = MerkleTree<String>.fromList(data);

      //   expect(tree.leafCount, equals(3));
      //   expect(tree.height, equals(2));

      //   // All proofs should be valid
      //   for (int i = 0; i < data.length; i++) {
      //     final proof = tree.generateProof(i);
      //     final isValid = tree.verifyProof(data[i], proof);
      //     expect(isValid, isTrue);
      //   }
      // });
    });

    group('Performance Tests', () {
      test('Proof generation performance', () {
        final data = List.generate(1000, (i) => 'perf_test_$i');
        final tree = MerkleTree<String>.fromList(data);

        final startTime = DateTime.now();
        for (int i = 0; i < 100; i++) {
          final proof = tree.generateProof(i % data.length);
          expect(proof.hashes.length, greaterThan(0));
        }
        final totalTime = DateTime.now().difference(startTime);

        expect(
          totalTime.inMilliseconds,
          lessThan(100),
        ); // Should complete quickly
      });

      // test('Proof verification performance', () {
      //   final data = List.generate(1000, (i) => 'verify_test_$i');
      //   final tree = MerkleTree<String>.fromList(data);
      //   final proof = tree.generateProof(500);

      //   final startTime = DateTime.now();
      //   for (int i = 0; i < 1000; i++) {
      //     final isValid = tree.verifyProof(data[500], proof);
      //     expect(isValid, isTrue);
      //   }
      //   final totalTime = DateTime.now().difference(startTime);

      //   expect(
      //     totalTime.inMilliseconds,
      //     lessThan(100),
      //   ); // Should complete quickly
      // });

      test('Tree update performance', () {
        final data = List.generate(1000, (i) => 'update_test_$i');
        var tree = MerkleTree<String>.fromList(data);

        final startTime = DateTime.now();
        for (int i = 0; i < 100; i++) {
          tree = tree.updateLeaf(i, 'updated_$i');
        }
        final totalTime = DateTime.now().difference(startTime);

        expect(
          totalTime.inMilliseconds,
          lessThan(1000),
        ); // Should complete reasonably quickly
        expect(tree.leafCount, equals(1000));
      });
    });
  });
}
