/// 🔐 Cryptographic Algorithms Example
///
/// This example demonstrates the usage of all cryptographic algorithms
/// implemented in the lunaris_engine library. Each algorithm is shown
/// with practical examples and common use cases.
///
/// Note: These are simplified implementations for educational purposes.
/// In production, use established cryptographic libraries.
///
/// Example:
/// ```bash
/// dart run example/cryptographic_algorithms_example.dart
/// ```
library;

import 'dart:typed_data';
import 'package:lunaris_engine/Cryptographic/sha256.dart';
import 'package:lunaris_engine/Cryptographic/ripemd160.dart';
import 'package:lunaris_engine/Cryptographic/keccak256.dart';
import 'package:lunaris_engine/Cryptographic/scrypt.dart';
import 'package:lunaris_engine/Cryptographic/argon2.dart';
import 'package:lunaris_engine/Cryptographic/ecdsa.dart';
import 'package:lunaris_engine/Cryptographic/eddsa.dart';
import 'package:lunaris_engine/Cryptographic/bls_signatures.dart';

void main() async {
  print('🔐 Cryptographic Algorithms Examples\n');

  // Test data
  const testMessage = 'Hello, World!';
  const testPassword = 'mySecurePassword123';
  const testSalt = 'randomSaltValue';

  print('📝 Test Message: "$testMessage"');
  print('🔑 Test Password: "$testPassword"');
  print('🧂 Test Salt: "$testSalt"\n');

  // SHA-256 Examples
  print('=== SHA-256 Examples ===');
  try {
    final sha256Hash = SHA256.hash(testMessage);
    print('SHA-256 Hash: $sha256Hash');

    final sha256Bytes = SHA256.hashBytes(
      Uint8List.fromList(testMessage.codeUnits),
    );
    print('SHA-256 Hash (bytes): $sha256Bytes');

    final sha256Raw = SHA256.hashRaw(Uint8List.fromList(testMessage.codeUnits));
    print(
      'SHA-256 Raw (first 16 bytes): ${sha256Raw.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
  } catch (e) {
    print('SHA-256 Error: $e');
  }
  print('');

  // RIPEMD-160 Examples
  print('=== RIPEMD-160 Examples ===');
  try {
    final ripemd160Hash = RIPEMD160.hash(testMessage);
    print('RIPEMD-160 Hash: $ripemd160Hash');

    final ripemd160Bytes = RIPEMD160.hashBytes(
      Uint8List.fromList(testMessage.codeUnits),
    );
    print('RIPEMD-160 Hash (bytes): $ripemd160Bytes');

    final ripemd160Raw = RIPEMD160.hashRaw(
      Uint8List.fromList(testMessage.codeUnits),
    );
    print(
      'RIPEMD-160 Raw (first 16 bytes): ${ripemd160Raw.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
  } catch (e) {
    print('RIPEMD-160 Error: $e');
  }
  print('');

  // Keccak-256 Examples
  print('=== Keccak-256 Examples ===');
  try {
    final keccak256Hash = Keccak256.hash(testMessage);
    print('Keccak-256 Hash: $keccak256Hash');

    final keccak256Bytes = Keccak256.hashBytes(
      Uint8List.fromList(testMessage.codeUnits),
    );
    print('Keccak-256 Hash (bytes): $keccak256Bytes');

    final keccak256Raw = Keccak256.hashRaw(
      Uint8List.fromList(testMessage.codeUnits),
    );
    print(
      'Keccak-256 Raw (first 16 bytes): ${keccak256Raw.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
  } catch (e) {
    print('Keccak-256 Error: $e');
  }
  print('');

  // Scrypt Examples
  print('=== Scrypt Examples ===');
  try {
    final scryptKey = await Scrypt.deriveKey(testPassword, testSalt);
    print('Scrypt Derived Key: $scryptKey');

    final scryptKeyBytes = await Scrypt.deriveKeyBytes(
      testPassword,
      testSalt,
      N: 8192,
      r: 8,
      p: 1,
      dkLen: 32,
    );
    print(
      'Scrypt Derived Key (custom params): ${scryptKeyBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
  } catch (e) {
    print('Scrypt Error: $e');
  }
  print('');

  // Argon2 Examples
  print('=== Argon2 Examples ===');
  try {
    final argon2Key = await Argon2.deriveKey(testPassword, testSalt);
    print('Argon2 Derived Key: $argon2Key');

    final argon2KeyBytes = await Argon2.deriveKeyBytes(
      testPassword,
      testSalt,
      t: 2,
      m: 32768,
      p: 2,
      dkLen: 32,
    );
    print(
      'Argon2 Derived Key (custom params): ${argon2KeyBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );

    // Test different variants
    final argon2dKey = await Argon2.deriveKey(
      testPassword,
      testSalt,
      variant: Argon2Variant.argon2d,
    );
    print('Argon2d Derived Key: $argon2dKey');

    final argon2iKey = await Argon2.deriveKey(
      testPassword,
      testSalt,
      variant: Argon2Variant.argon2i,
    );
    print('Argon2i Derived Key: $argon2iKey');
  } catch (e) {
    print('Argon2 Error: $e');
  }
  print('');

  // ECDSA Examples
  print('=== ECDSA Examples ===');
  try {
    // Generate key pair
    final ecdsaKeyPair = ECDSAKeyPair.generate();
    print('ECDSA Private Key: ${ecdsaKeyPair.privateKey.toRadixString(16)}');
    print(
      'ECDSA Public Key: (${ecdsaKeyPair.publicKey.x.toRadixString(16)}, ${ecdsaKeyPair.publicKey.y.toRadixString(16)})',
    );

    // Sign message
    final ecdsaSignature = ECDSA.sign(testMessage, ecdsaKeyPair.privateKey);
    print('ECDSA Signature R: ${ecdsaSignature.r.toRadixString(16)}');
    print('ECDSA Signature S: ${ecdsaSignature.s.toRadixString(16)}');

    // Verify signature
    final ecdsaValid = ECDSA.verify(
      testMessage,
      ecdsaSignature,
      ecdsaKeyPair.publicKey,
    );
    print('ECDSA Signature Valid: $ecdsaValid');

    // Test DER format
    final ecdsaDer = ecdsaSignature.toDER();
    print(
      'ECDSA DER Signature (first 16 bytes): ${ecdsaDer.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );

    // Test compact format
    final ecdsaCompact = ecdsaSignature.toCompact();
    print(
      'ECDSA Compact Signature (first 16 bytes): ${ecdsaCompact.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
  } catch (e) {
    print('ECDSA Error: $e');
  }
  print('');

  // EdDSA Examples
  print('=== EdDSA Examples ===');
  try {
    // Generate key pair
    final eddsaKeyPair = EdDSAKeyPair.generate();
    print(
      'EdDSA Private Key: ${eddsaKeyPair.privateKey.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
    print(
      'EdDSA Public Key: ${eddsaKeyPair.publicKey.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );

    // Sign message
    final eddsaSignature = EdDSA.sign(testMessage, eddsaKeyPair.privateKey);
    print(
      'EdDSA Signature R: ${eddsaSignature.R.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
    print(
      'EdDSA Signature S: ${eddsaSignature.S.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );

    // Verify signature
    final eddsaValid = EdDSA.verify(
      testMessage,
      eddsaSignature,
      eddsaKeyPair.publicKey,
    );
    print('EdDSA Signature Valid: $eddsaValid');

    // Test bytes format
    final eddsaBytes = eddsaSignature.toBytes();
    print(
      'EdDSA Bytes Signature (first 16 bytes): ${eddsaBytes.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
  } catch (e) {
    print('EdDSA Error: $e');
  }
  print('');

  // BLS Signatures Examples
  print('=== BLS Signatures Examples ===');
  try {
    // Generate key pair
    final blsKeyPair = BLSKeyPair.generate();
    print(
      'BLS Private Key: ${blsKeyPair.privateKey.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
    print(
      'BLS Public Key: ${blsKeyPair.publicKey.publicKey.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );

    // Sign message
    final blsSignature = BLSSignatures.sign(testMessage, blsKeyPair.privateKey);
    print(
      'BLS Signature: ${blsSignature.signature.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );

    // Verify signature
    final blsValid = BLSSignatures.verify(
      testMessage,
      blsSignature,
      blsKeyPair.publicKey,
    );
    print('BLS Signature Valid: $blsValid');

    // Test aggregation
    final blsKeyPair2 = BLSKeyPair.generate();
    final blsSignature2 = BLSSignatures.sign(
      testMessage,
      blsKeyPair2.privateKey,
    );

    final aggregatedSignature = BLSSignature.aggregate([
      blsSignature,
      blsSignature2,
    ]);
    final aggregatedPublicKey = BLSPublicKey.aggregate([
      blsKeyPair.publicKey,
      blsKeyPair2.publicKey,
    ]);

    final aggregatedValid = BLSSignatures.verifyAggregatedSameMessage(
      testMessage,
      aggregatedSignature,
      aggregatedPublicKey,
    );
    print('BLS Aggregated Signature Valid: $aggregatedValid');

    // Test bytes format
    final blsBytes = blsSignature.toBytes();
    print(
      'BLS Bytes Signature (first 16 bytes): ${blsBytes.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
    );
  } catch (e) {
    print('BLS Signatures Error: $e');
  }
  print('');

  // Performance Comparison
  print('=== Performance Comparison ===');
  try {
    final stopwatch = Stopwatch();

    // SHA-256 performance
    stopwatch.start();
    for (int i = 0; i < 1000; i++) {
      SHA256.hash('$testMessage$i');
    }
    stopwatch.stop();
    print('SHA-256 (1000 hashes): ${stopwatch.elapsedMilliseconds}ms');

    // RIPEMD-160 performance
    stopwatch.reset();
    stopwatch.start();
    for (int i = 0; i < 1000; i++) {
      RIPEMD160.hash('$testMessage$i');
    }
    stopwatch.stop();
    print('RIPEMD-160 (1000 hashes): ${stopwatch.elapsedMilliseconds}ms');

    // Keccak-256 performance
    stopwatch.reset();
    stopwatch.start();
    for (int i = 0; i < 1000; i++) {
      Keccak256.hash('$testMessage$i');
    }
    stopwatch.stop();
    print('Keccak-256 (1000 hashes): ${stopwatch.elapsedMilliseconds}ms');
  } catch (e) {
    print('Performance Test Error: $e');
  }
  print('');

  print('✅ All cryptographic algorithm examples completed!');
  print(
    '📚 For production use, consider using established cryptographic libraries.',
  );
}
