import 'package:lunaris_engine/Cryptographic/sha256.dart';
import 'package:lunaris_engine/Cryptographic/ripemd160.dart';
import 'package:lunaris_engine/Cryptographic/keccak256.dart';
import 'package:lunaris_engine/Cryptographic/scrypt.dart';
import 'package:lunaris_engine/Cryptographic/argon2.dart';
import 'package:lunaris_engine/Cryptographic/ecdsa.dart';
import 'package:lunaris_engine/Cryptographic/eddsa.dart';
import 'package:lunaris_engine/Cryptographic/bls_signatures.dart';
import 'package:test/test.dart';
import 'dart:typed_data';

void main() {
  group('Cryptographic Algorithms Integration Tests', () {
    const testMessage = 'Hello, World!';
    const testPassword = 'mySecurePassword123';
    const testSalt = 'randomSaltValue';

    group('Hash Functions', () {
      test('SHA-256 produces correct hash length', () {
        final hash = SHA256.hash(testMessage);
        expect(hash.length, 64); // 32 bytes = 64 hex characters
      });

      test('RIPEMD-160 produces correct hash length', () {
        final hash = RIPEMD160.hash(testMessage);
        expect(hash.length, 40); // 20 bytes = 40 hex characters
      });

      test('Keccak-256 produces correct hash length', () {
        final hash = Keccak256.hash(testMessage);
        expect(hash.length, 64); // 32 bytes = 64 hex characters
      });

      test('All hash functions produce different outputs for same input', () {
        final sha256Hash = SHA256.hash(testMessage);
        final ripemd160Hash = RIPEMD160.hash(testMessage);
        final keccak256Hash = Keccak256.hash(testMessage);

        expect(sha256Hash, isNot(equals(ripemd160Hash)));
        expect(sha256Hash, isNot(equals(keccak256Hash)));
        expect(ripemd160Hash, isNot(equals(keccak256Hash)));
      });
    });

    group('Key Derivation Functions', () {
      test('Scrypt produces correct key length', () async {
        final key = await Scrypt.deriveKeyBytes(
          testPassword,
          testSalt,
          dkLen: 32,
        );
        expect(key.length, 32);
      });

      test('Argon2 produces correct key length', () async {
        final key = await Argon2.deriveKeyBytes(
          testPassword,
          testSalt,
          dkLen: 32,
        );
        expect(key.length, 32);
      });

      test('Different salts produce different keys', () async {
        final key1 = await Scrypt.deriveKey(testPassword, testSalt);
        final key2 = await Scrypt.deriveKey(testPassword, 'differentSalt');
        expect(key1, isNot(equals(key2)));
      });

      test('Different passwords produce different keys', () async {
        final key1 = await Scrypt.deriveKey(testPassword, testSalt);
        final key2 = await Scrypt.deriveKey('differentPassword', testSalt);
        expect(key1, isNot(equals(key2)));
      });
    });

    group('Digital Signature Algorithms', () {
      test('ECDSA key pair generation', () {
        final keyPair = ECDSAKeyPair.generate();
        expect(keyPair.privateKey, isA<BigInt>());
        expect(keyPair.publicKey, isA<ECPoint>());
        expect(keyPair.publicKey.isInfinity, false);
      });

      test('EdDSA key pair generation', () {
        final keyPair = EdDSAKeyPair.generate();
        expect(keyPair.privateKey.length, 32);
        expect(
          keyPair.publicKey.length,
          32,
        ); // Ed25519 uses 32-byte public keys
      });

      test('BLS key pair generation', () {
        final keyPair = BLSKeyPair.generate();
        expect(keyPair.privateKey.length, 32);
        expect(keyPair.publicKey.publicKey.length, 48);
      });

      // test('ECDSA signing and verification', () {
      //   final keyPair = ECDSAKeyPair.generate();
      //   final signature = ECDSA.sign(testMessage, keyPair.privateKey);
      //   final isValid = ECDSA.verify(testMessage, signature, keyPair.publicKey);
      //   expect(isValid, true);
      // });

      // test('EdDSA signing and verification', () {
      //   final keyPair = EdDSAKeyPair.generate();
      //   final signature = EdDSA.sign(testMessage, keyPair.privateKey);
      //   final isValid = EdDSA.verify(testMessage, signature, keyPair.publicKey);
      //   expect(isValid, true);
      // });

      // test('BLS signing and verification', () {
      //   final keyPair = BLSKeyPair.generate();
      //   final signature = BLSSignatures.sign(testMessage, keyPair.privateKey);
      //   final isValid = BLSSignatures.verify(
      //     testMessage,
      //     signature,
      //     keyPair.publicKey,
      //   );
      //   expect(isValid, true);
      // });
    });

    group('Signature Formats', () {
      test('ECDSA DER format', () {
        final keyPair = ECDSAKeyPair.generate();
        final signature = ECDSA.sign(testMessage, keyPair.privateKey);
        final der = signature.toDER();
        expect(der, isA<Uint8List>());
        expect(der.length, greaterThan(0));
      });

      test('ECDSA compact format', () {
        final keyPair = ECDSAKeyPair.generate();
        final signature = ECDSA.sign(testMessage, keyPair.privateKey);
        final compact = signature.toCompact();
        expect(compact.length, 64);
      });

      test('EdDSA bytes format', () {
        final keyPair = EdDSAKeyPair.generate();
        final signature = EdDSA.sign(testMessage, keyPair.privateKey);
        final bytes = signature.toBytes();
        expect(bytes.length, 64);
      });

      test('BLS bytes format', () {
        final keyPair = BLSKeyPair.generate();
        final signature = BLSSignatures.sign(testMessage, keyPair.privateKey);
        final bytes = signature.toBytes();
        expect(bytes.length, 96);
      });
    });

    group('Aggregation Tests', () {
      test('BLS signature aggregation', () {
        final keyPair1 = BLSKeyPair.generate();
        final keyPair2 = BLSKeyPair.generate();

        final signature1 = BLSSignatures.sign(testMessage, keyPair1.privateKey);
        final signature2 = BLSSignatures.sign(testMessage, keyPair2.privateKey);

        final aggregatedSignature = BLSSignature.aggregate([
          signature1,
          signature2,
        ]);
        expect(aggregatedSignature, isA<BLSSignature>());
      });

      test('BLS public key aggregation', () {
        final keyPair1 = BLSKeyPair.generate();
        final keyPair2 = BLSKeyPair.generate();

        final aggregatedPublicKey = BLSPublicKey.aggregate([
          keyPair1.publicKey,
          keyPair2.publicKey,
        ]);
        expect(aggregatedPublicKey, isA<BLSPublicKey>());
      });

      // test('BLS aggregated signature verification', () {
      //   final keyPair1 = BLSKeyPair.generate();
      //   final keyPair2 = BLSKeyPair.generate();

      //   final signature1 = BLSSignatures.sign(testMessage, keyPair1.privateKey);
      //   final signature2 = BLSSignatures.sign(testMessage, keyPair2.privateKey);

      //   final aggregatedSignature = BLSSignature.aggregate([
      //     signature1,
      //     signature2,
      //   ]);
      //   final aggregatedPublicKey = BLSPublicKey.aggregate([
      //     keyPair1.publicKey,
      //     keyPair2.publicKey,
      //   ]);

      //   final isValid = BLSSignatures.verifyAggregatedSameMessage(
      //     testMessage,
      //     aggregatedSignature,
      //     aggregatedPublicKey,
      //   );
      //   expect(isValid, true);
      // });
    });

    group('Error Handling', () {
      test('Invalid signature verification returns false', () {
        final keyPair = ECDSAKeyPair.generate();
        final invalidSignature = ECDSASignature(BigInt.one, BigInt.one);
        final isValid = ECDSA.verify(
          testMessage,
          invalidSignature,
          keyPair.publicKey,
        );
        expect(isValid, false);
      });

      test('Empty signature list aggregation throws error', () {
        expect(() => BLSSignature.aggregate([]), throwsArgumentError);
      });

      test('Empty public key list aggregation throws error', () {
        expect(() => BLSPublicKey.aggregate([]), throwsArgumentError);
      });
    });

    group('Performance Tests', () {
      test('Hash function performance', () {
        final stopwatch = Stopwatch();
        final testData = 'Performance test data';

        stopwatch.start();
        for (int i = 0; i < 100; i++) {
          SHA256.hash('$testData$i');
          RIPEMD160.hash('$testData$i');
          Keccak256.hash('$testData$i');
        }
        stopwatch.stop();

        // Should complete 300 hashes in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('Key derivation performance', () async {
        final stopwatch = Stopwatch();

        stopwatch.start();
        // Use faster parameters for testing while maintaining security
        await Scrypt.deriveKeyBytes(
          testPassword,
          testSalt,
          N: 1024, // Reduced from 16384 for testing
          r: 8,
          p: 1,
          dkLen: 32,
        );
        await Argon2.deriveKeyBytes(
          testPassword,
          testSalt,
          variant: Argon2Variant.argon2id,
          t: 1, // Reduced from default for testing
          m: 1024, // Reduced from default for testing
          p: 1,
          dkLen: 32,
        );
        stopwatch.stop();

        // Should complete in reasonable time for testing parameters
        // Note: Production use would use higher parameters and take longer
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(30000),
        ); // 30 seconds for testing
      });
    });

    group('Edge Cases', () {
      test('Very long input handling', () {
        final longInput = 'A' * 100000;

        final sha256Hash = SHA256.hash(longInput);
        final ripemd160Hash = RIPEMD160.hash(longInput);
        final keccak256Hash = Keccak256.hash(longInput);

        expect(sha256Hash.length, 64);
        expect(ripemd160Hash.length, 40);
        expect(keccak256Hash.length, 64);
      });

      test('Empty input handling', () {
        final sha256Hash = SHA256.hash('');
        final ripemd160Hash = RIPEMD160.hash('');
        final keccak256Hash = Keccak256.hash('');

        expect(sha256Hash.length, 64);
        expect(ripemd160Hash.length, 40);
        expect(keccak256Hash.length, 64);
      });

      test('Special characters handling', () {
        final specialInput = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

        final sha256Hash = SHA256.hash(specialInput);
        final ripemd160Hash = RIPEMD160.hash(specialInput);
        final keccak256Hash = Keccak256.hash(specialInput);

        expect(sha256Hash.length, 64);
        expect(ripemd160Hash.length, 40);
        expect(keccak256Hash.length, 64);
      });
    });
  });
}
