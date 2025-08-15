/// ⛏️ Scrypt Mining Algorithm Example
///
/// This example demonstrates the usage of the Scrypt mining algorithm
/// for cryptocurrency mining operations, particularly Litecoin.
/// Each mining scenario is shown with practical examples and common use cases.
///
/// Note: This is a production-ready implementation for enterprise use.
/// Suitable for high-performance mining operations and blockchain applications.
///
/// Example:
/// ```bash
/// dart run example/scrypt_mining_example.dart
/// ```
library;

import 'dart:typed_data';
import 'package:lunaris_engine/Cryptographic/scrypt_mining.dart';

void main() {
  print('⛏️ Scrypt Mining Algorithm Examples\n');

  // Test data for mining operations
  final testBlockHeader = Uint8List.fromList('TestBlockHeader123'.codeUnits);
  final testSalt = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
  final testNonce = Uint8List.fromList([0, 0, 0, 0]);

  print('📝 Test Block Header: "${String.fromCharCodes(testBlockHeader)}"');
  print(
    '🧂 Test Salt: ${testSalt.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
  );
  print(
    '🔢 Test Nonce: ${testNonce.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}\n',
  );

  // Litecoin Mainnet Examples
  print('=== Litecoin Mainnet Examples ===');
  try {
    final mainnetParams = ScryptMiningParams.litecoinMainnet(
      blockHeader: testBlockHeader,
      salt: testSalt,
    );

    final mainnetHash = ScryptMining.hash(mainnetParams);
    print('Litecoin Mainnet Hash: $mainnetHash');
    print(
      'Hash Length: ${mainnetHash.length} characters (${mainnetHash.length ~/ 2} bytes)',
    );

    final mainnetHashBytes = ScryptMining.hashRawBytes(mainnetParams);
    print(
      'Mainnet Hash Bytes: ${mainnetHashBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
  } catch (e) {
    print('Litecoin Mainnet Error: $e');
  }
  print('');

  // Litecoin Testnet Examples
  print('=== Litecoin Testnet Examples ===');
  try {
    final testnetParams = ScryptMiningParams.litecoinTestnet(
      blockHeader: testBlockHeader,
      salt: testSalt,
    );

    final testnetHash = ScryptMining.hash(testnetParams);
    print('Litecoin Testnet Hash: $testnetHash');
    print(
      'Hash Length: ${testnetHash.length} characters (${testnetHash.length ~/ 2} bytes)',
    );

    final testnetHashBytes = ScryptMining.hashRawBytes(testnetParams);
    print(
      'Testnet Hash Bytes: ${testnetHashBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
  } catch (e) {
    print('Litecoin Testnet Error: $e');
  }
  print('');

  // Custom Mining Parameters Examples
  print('=== Custom Mining Parameters Examples ===');
  try {
    // High difficulty mining (higher N value)
    final highDifficultyParams = ScryptMiningParams.custom(
      N: 2048, // Higher CPU cost
      r: 2, // Higher memory cost
      p: 2, // Higher parallelism
      dkLen: 64, // Longer output
      salt: testSalt,
      password: testBlockHeader,
    );

    final highDifficultyHash = ScryptMining.hash(highDifficultyParams);
    print('High Difficulty Hash: $highDifficultyHash');
    print(
      'Hash Length: ${highDifficultyHash.length} characters (${highDifficultyHash.length ~/ 2} bytes)',
    );

    // Low difficulty mining (lower N value)
    final lowDifficultyParams = ScryptMiningParams.custom(
      N: 512, // Lower CPU cost
      r: 1, // Lower memory cost
      p: 1, // Lower parallelism
      dkLen: 16, // Shorter output
      salt: testSalt,
      password: testBlockHeader,
    );

    final lowDifficultyHash = ScryptMining.hash(lowDifficultyParams);
    print('Low Difficulty Hash: $lowDifficultyHash');
    print(
      'Hash Length: ${lowDifficultyHash.length} characters (${lowDifficultyHash.length ~/ 2} bytes)',
    );
  } catch (e) {
    print('Custom Parameters Error: $e');
  }
  print('');

  // Raw Hash Examples
  print('=== Raw Hash Examples ===');
  try {
    final rawHash = ScryptMining.hashRaw(
      testBlockHeader,
      testSalt,
      N: 1024,
      r: 1,
      p: 1,
      dkLen: 32,
    );
    print('Raw Hash: $rawHash');
    print(
      'Hash Length: ${rawHash.length} characters (${rawHash.length ~/ 2} bytes)',
    );

    // Different parameters
    final rawHash2 = ScryptMining.hashRaw(
      testBlockHeader,
      testSalt,
      N: 512,
      r: 1,
      p: 1,
      dkLen: 32,
    );
    print('Raw Hash (N=512): $rawHash2');
    print(
      'Hash Length: ${rawHash2.length} characters (${rawHash2.length ~/ 2} bytes)',
    );
  } catch (e) {
    print('Raw Hash Error: $e');
  }
  print('');

  // Mining Simulation Examples
  print('=== Mining Simulation Examples ===');
  try {
    // Simulate mining with different nonces
    print('Simulating mining with different nonces...');

    for (int nonce = 0; nonce < 5; nonce++) {
      final nonceBytes = Uint8List.fromList([
        nonce & 0xFF,
        (nonce >> 8) & 0xFF,
        (nonce >> 16) & 0xFF,
        (nonce >> 24) & 0xFF,
      ]);

      // Combine block header with nonce
      final miningData = Uint8List.fromList([
        ...testBlockHeader,
        ...nonceBytes,
      ]);

      final miningParams = ScryptMiningParams.litecoinTestnet(
        blockHeader: miningData,
        salt: testSalt,
      );

      final miningHash = ScryptMining.hash(miningParams);
      print(
        'Nonce $nonce: ${miningHash.substring(0, 16)}... (${miningHash.length} chars)',
      );
    }
  } catch (e) {
    print('Mining Simulation Error: $e');
  }
  print('');

  // Performance Comparison Examples
  print('=== Performance Comparison Examples ===');
  try {
    final stopwatch = Stopwatch();

    // Test mainnet performance
    final mainnetParams = ScryptMiningParams.litecoinMainnet(
      blockHeader: testBlockHeader,
      salt: testSalt,
    );

    stopwatch.start();
    for (int i = 0; i < 3; i++) {
      // Reduced iterations for faster execution
      ScryptMining.hash(mainnetParams);
    }
    stopwatch.stop();
    print('Mainnet (3 hashes): ${stopwatch.elapsedMilliseconds}ms');

    // Test testnet performance
    final testnetParams = ScryptMiningParams.litecoinTestnet(
      blockHeader: testBlockHeader,
      salt: testSalt,
    );

    stopwatch.reset();
    stopwatch.start();
    for (int i = 0; i < 3; i++) {
      ScryptMining.hash(testnetParams);
    }
    stopwatch.stop();
    print('Testnet (3 hashes): ${stopwatch.elapsedMilliseconds}ms');

    // Test custom parameters performance
    final customParams = ScryptMiningParams.custom(
      N: 512,
      r: 1,
      p: 1,
      dkLen: 32,
      salt: testSalt,
      password: testBlockHeader,
    );

    stopwatch.reset();
    stopwatch.start();
    for (int i = 0; i < 3; i++) {
      ScryptMining.hash(customParams);
    }
    stopwatch.stop();
    print('Custom N=512 (3 hashes): ${stopwatch.elapsedMilliseconds}ms');
  } catch (e) {
    print('Performance Comparison Error: $e');
  }
  print('');

  // Error Handling Examples
  print('=== Error Handling Examples ===');
  try {
    // Test invalid N parameter (not power of 2)
    print('Testing invalid N parameter (N=3)...');
    try {
      final invalidParams = ScryptMiningParams.custom(
        N: 3, // Invalid: not a power of 2
        r: 1,
        p: 1,
        dkLen: 32,
        salt: testSalt,
        password: testBlockHeader,
      );
      ScryptMining.hash(invalidParams);
      print('Unexpected success with invalid N=3');
    } catch (e) {
      print('Correctly caught error: $e');
    }

    // Test invalid r parameter (zero)
    print('Testing invalid r parameter (r=0)...');
    try {
      final invalidParams = ScryptMiningParams.custom(
        N: 1024,
        r: 0, // Invalid: must be positive
        p: 1,
        dkLen: 32,
        salt: testSalt,
        password: testBlockHeader,
      );
      ScryptMining.hash(invalidParams);
      print('Unexpected success with invalid r=0');
    } catch (e) {
      print('Correctly caught error: $e');
    }

    // Test invalid p parameter (negative)
    print('Testing invalid p parameter (p=-1)...');
    try {
      final invalidParams = ScryptMiningParams.custom(
        N: 1024,
        r: 1,
        p: -1, // Invalid: must be positive
        dkLen: 32,
        salt: testSalt,
        password: testBlockHeader,
      );
      ScryptMining.hash(invalidParams);
      print('Unexpected success with invalid p=-1');
    } catch (e) {
      print('Correctly caught error: $e');
    }
  } catch (e) {
    print('Error Handling Test Error: $e');
  }
  print('');

  print('✅ All Scrypt mining algorithm examples completed!');
  print(
    '🚀 This implementation is production-ready for enterprise mining operations.',
  );
  print('📚 Suitable for Litecoin and other Scrypt-based cryptocurrencies.');
}
