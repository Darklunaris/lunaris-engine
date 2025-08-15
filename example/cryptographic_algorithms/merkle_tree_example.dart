/// 🌳 Merkle Tree Example - Demonstrating Blockchain and Distributed Systems Usage
///
/// This example showcases the production-ready Merkle Tree implementation with
/// various use cases including blockchain block verification, data integrity
/// checking, and efficient proof generation for distributed systems.
///
/// Example:
/// ```bash
/// dart run example/merkle_tree_example.dart
/// ```
library;

import 'dart:math';
import 'package:lunaris_engine/Tree/merkle_tree.dart';

void main() {
  print('🌳 Merkle Tree Examples\n');

  // Example 1: Basic Merkle Tree Creation
  print('=== Example 1: Basic Merkle Tree Creation ===');
  _demonstrateBasicTree();

  // Example 2: Blockchain Block Verification
  print('\n=== Example 2: Blockchain Block Verification ===');
  _demonstrateBlockchainUsage();

  // Example 3: Data Integrity Verification
  print('\n=== Example 3: Data Integrity Verification ===');
  _demonstrateDataIntegrity();

  // Example 4: Batch Operations
  print('\n=== Example 4: Batch Operations ===');
  _demonstrateBatchOperations();

  // Example 5: Custom Hash Functions
  print('\n=== Example 5: Custom Hash Functions ===');
  _demonstrateCustomHashFunctions();

  // Example 6: Performance Benchmarking
  print('\n=== Example 6: Performance Benchmarking ===');
  _demonstratePerformance();

  print('\n✅ All Merkle Tree examples completed successfully!');
}

/// Demonstrates basic Merkle tree creation and operations
void _demonstrateBasicTree() {
  // Create a simple Merkle tree with string data
  final data = ['block1', 'block2', 'block3', 'block4'];
  print('Creating Merkle tree with data: $data');

  final merkleTree = MerkleTree<String>.fromList(data);

  print('Tree created successfully!');
  print('  - Leaf count: ${merkleTree.leafCount}');
  print('  - Tree height: ${merkleTree.height}');
  print('  - Root hash: ${merkleTree.rootHash?.substring(0, 16)}...');
  print('  - Leaf hashes: ${merkleTree.leafHashes.length}');

  // Generate and verify a proof
  final proof = merkleTree.generateProof(2);
  print('  - Generated proof for index 2: ${proof.hashes.length} hashes');

  final isValid = merkleTree.verifyProof('block3', proof);
  print('  - Proof verification: $isValid');

  // Test with invalid data
  final invalidProof = merkleTree.verifyProof('invalid_block', proof);
  print('  - Invalid data verification: $invalidProof');
}

/// Demonstrates blockchain-specific usage patterns
void _demonstrateBlockchainUsage() {
  print('Simulating blockchain block verification...');

  // Create blocks with transaction data
  final blocks = [
    '{"block": 1, "transactions": ["tx1", "tx2", "tx3"], "timestamp": "${DateTime.now().toIso8601String()}"}',
    '{"block": 2, "transactions": ["tx4", "tx5"], "timestamp": "${DateTime.now().toIso8601String()}"}',
    '{"block": 3, "transactions": ["tx6", "tx7", "tx8", "tx9"], "timestamp": "${DateTime.now().toIso8601String()}"}',
    '{"block": 4, "transactions": ["tx10"], "timestamp": "${DateTime.now().toIso8601String()}"}',
    '{"block": 5, "transactions": ["tx11", "tx12", "tx13"], "timestamp": "${DateTime.now().toIso8601String()}"}',
  ];

  final blockchainTree = MerkleTree<String>.fromList(blocks);

  print('  - Blockchain tree created with ${blockchainTree.leafCount} blocks');
  print('  - Root hash: ${blockchainTree.rootHash?.substring(0, 16)}...');

  // Simulate block verification
  for (int i = 0; i < blocks.length; i++) {
    final proof = blockchainTree.generateProof(i);
    final isValid = blockchainTree.verifyProof(blocks[i], proof);

    print('  - Block ${i + 1} verification: $isValid');

    if (isValid) {
      print('    ✓ Block ${i + 1} is part of the valid blockchain');
    } else {
      print('    ✗ Block ${i + 1} verification failed');
    }
  }

  // Test block tampering detection
  final tamperedBlock =
      '{"block": 2, "transactions": ["tx4", "tx5", "tx_tampered"], "timestamp": "${DateTime.now().toIso8601String()}"}';
  final tamperedProof = blockchainTree.generateProof(
    1,
  ); // Index 1 corresponds to block 2

  final tamperedValid = blockchainTree.verifyProof(
    tamperedBlock,
    tamperedProof,
  );
  print('  - Tampered block verification: $tamperedValid (should be false)');
}

/// Demonstrates data integrity verification scenarios
void _demonstrateDataIntegrity() {
  print('Demonstrating data integrity verification...');

  // Create a large dataset
  final largeData = List.generate(
    1000,
    (i) => 'data_chunk_${i.toString().padLeft(4, '0')}',
  );

  final startTime = DateTime.now();
  final integrityTree = MerkleTree<String>.fromList(largeData);
  final creationTime = DateTime.now().difference(startTime);

  print(
    '  - Created integrity tree with ${integrityTree.leafCount} chunks in ${creationTime.inMilliseconds}ms',
  );
  print('  - Tree height: ${integrityTree.height}');

  // Simulate data corruption detection
  final random = Random();
  final corruptedIndex = random.nextInt(largeData.length);
  final corruptedData = 'corrupted_chunk_$corruptedIndex';

  final proof = integrityTree.generateProof(corruptedIndex);
  final originalValid = integrityTree.verifyProof(
    largeData[corruptedIndex],
    proof,
  );
  final corruptedValid = integrityTree.verifyProof(corruptedData, proof);

  print('  - Original data verification: $originalValid');
  print('  - Corrupted data verification: $corruptedValid (should be false)');
  print('  - Corruption detected at index: $corruptedIndex');

  // Test partial data verification
  final testIndices = [0, 100, 500, 999];
  for (final index in testIndices) {
    final testProof = integrityTree.generateProof(index);
    final testValid = integrityTree.verifyProof(largeData[index], testProof);
    print('  - Index $index verification: $testValid');
  }
}

/// Demonstrates batch operations for efficiency
void _demonstrateBatchOperations() {
  print('Demonstrating batch operations...');

  // Create initial tree
  final initialData = List.generate(100, (i) => 'item_$i');
  var merkleTree = MerkleTree<String>.fromList(initialData);

  print('  - Initial tree: ${merkleTree.leafCount} items');
  print('  - Initial root: ${merkleTree.rootHash?.substring(0, 16)}...');

  // Single update
  final startTime = DateTime.now();
  merkleTree = merkleTree.updateLeaf(50, 'updated_item_50');
  final singleUpdateTime = DateTime.now().difference(startTime);

  print('  - Single update completed in ${singleUpdateTime.inMicroseconds}μs');
  print('  - New root: ${merkleTree.rootHash?.substring(0, 16)}...');

  // Batch update
  final batchUpdates = <int, String>{};
  for (int i = 0; i < 10; i++) {
    batchUpdates[i] = 'batch_updated_item_$i';
  }

  final batchStartTime = DateTime.now();
  merkleTree = merkleTree.updateLeavesBatch(batchUpdates);
  final batchUpdateTime = DateTime.now().difference(batchStartTime);

  print(
    '  - Batch update (10 items) completed in ${batchUpdateTime.inMicroseconds}μs',
  );
  print('  - Final root: ${merkleTree.rootHash?.substring(0, 16)}...');

  // Verify batch updates
  for (final entry in batchUpdates.entries) {
    final proof = merkleTree.generateProof(entry.key);
    final isValid = merkleTree.verifyProof(entry.value, proof);
    print('  - Batch item ${entry.key} verification: $isValid');
  }
}

/// Demonstrates custom hash functions
void _demonstrateCustomHashFunctions() {
  print('Demonstrating custom hash functions...');

  // Custom hash function that adds a salt
  String customHash(String data) {
    final salt = 'custom_salt_2024';
    final combined = data + salt;

    int hash = 0;
    for (int i = 0; i < combined.length; i++) {
      final char = combined.codeUnitAt(i);
      hash = ((hash << 5) - hash + char) & 0xFFFFFFFF;
    }

    return hash.toRadixString(16).padLeft(8, '0');
  }

  final data = ['secure_data_1', 'secure_data_2', 'secure_data_3'];

  final customTree = MerkleTree<String>.fromList(
    data,
    hashFunction: customHash,
    salt: 'additional_security',
  );

  print('  - Custom hash tree created');
  print('  - Root hash: ${customTree.rootHash?.substring(0, 16)}...');

  // Verify with custom hash
  final proof = customTree.generateProof(1);
  final isValid = customTree.verifyProof('secure_data_2', proof);

  print('  - Custom hash verification: $isValid');

  // Test that different hash functions produce different results
  final defaultTree = MerkleTree<String>.fromList(data);
  print('  - Default hash root: ${defaultTree.rootHash?.substring(0, 16)}...');
  print('  - Custom hash root: ${customTree.rootHash?.substring(0, 16)}...');
  print(
    '  - Roots are different: ${defaultTree.rootHash != customTree.rootHash}',
  );
}

/// Demonstrates performance characteristics
void _demonstratePerformance() {
  print('Demonstrating performance characteristics...');

  // Test different sizes
  final sizes = [100, 1000, 10000];

  for (final size in sizes) {
    final data = List.generate(size, (i) => 'performance_test_item_$i');

    // Measure creation time
    final startTime = DateTime.now();
    final tree = MerkleTree<String>.fromList(data);
    final creationTime = DateTime.now().difference(startTime);

    // Measure proof generation time
    final proofStartTime = DateTime.now();
    final proof = tree.generateProof(size ~/ 2);
    final proofTime = DateTime.now().difference(proofStartTime);

    // Measure verification time
    final verifyStartTime = DateTime.now();
    final isValid = tree.verifyProof(data[size ~/ 2], proof);
    final verifyTime = DateTime.now().difference(verifyStartTime);

    print('  - Size $size:');
    print('    • Creation: ${creationTime.inMilliseconds}ms');
    print('    • Proof generation: ${proofTime.inMicroseconds}μs');
    print('    • Verification: ${verifyTime.inMicroseconds}μs');
    print('    • Verification result: $isValid');
    print('    • Tree height: ${tree.height}');
  }

  // Memory usage estimation
  final largeData = List.generate(100000, (i) => 'large_scale_item_$i');
  final largeTree = MerkleTree<String>.fromList(largeData);

  print('  - Large scale tree (100,000 items):');
  print('    • Leaf count: ${largeTree.leafCount}');
  print('    • Tree height: ${largeTree.height}');
  print(
    '    • Estimated memory: ~${(largeTree.leafCount * 64 / 1024).round()}KB (approximate)',
  );
}
