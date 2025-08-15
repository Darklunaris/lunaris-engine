import 'package:lunaris_engine/Cryptographic/sha256.dart';
import 'package:test/test.dart';
import 'dart:typed_data'; // Added for Uint8List
import 'dart:io'; // Added for ProcessInfo

void main() {
  group('SHA256 Tests', () {
    test('Empty string hash', () {
      final hash = SHA256.hash('');
      expect(
        hash,
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
    });

    test('Simple string hash', () {
      final hash = SHA256.hash('Hello, World!');
      expect(
        hash,
        'dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986f',
      );
    });

    test('Long string hash', () {
      final longString = 'A' * 1000;
      final hash = SHA256.hash(longString);
      expect(hash.length, 64); // SHA-256 produces 64 hex characters
      expect(hash, isA<String>());
    });

    test('Unicode string hash', () {
      final unicodeString = 'Hello, 世界! 🌍';
      final hash = SHA256.hash(unicodeString);
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Bytes hash', () {
      final bytes = [72, 101, 108, 108, 111]; // "Hello"
      final hash = SHA256.hashBytes(Uint8List.fromList(bytes));
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Raw hash bytes', () {
      final bytes = [72, 101, 108, 108, 111]; // "Hello"
      final hashBytes = SHA256.hashRaw(Uint8List.fromList(bytes));
      expect(hashBytes.length, 32); // SHA-256 produces 32 bytes
      expect(hashBytes, isA<Uint8List>());
    });

    test('Consistent hashing', () {
      final input = 'Test input for consistency';
      final hash1 = SHA256.hash(input);
      final hash2 = SHA256.hash(input);
      expect(hash1, equals(hash2));
    });

    test('Different inputs produce different hashes', () {
      final hash1 = SHA256.hash('input1');
      final hash2 = SHA256.hash('input2');
      expect(hash1, isNot(equals(hash2)));
    });

    test('Hash avalanche effect', () {
      final input1 = 'Hello, World!';
      final input2 = 'Hello, World?';
      final hash1 = SHA256.hash(input1);
      final hash2 = SHA256.hash(input2);

      // The hashes should be completely different
      expect(hash1, isNot(equals(hash2)));

      // Count different characters (should be close to 50%)
      int differences = 0;
      for (int i = 0; i < hash1.length; i++) {
        if (hash1[i] != hash2[i]) differences++;
      }

      // With 64 characters, we expect significant differences
      expect(differences, greaterThan(20));
    });

    test('Large data handling', () {
      final largeData = List.generate(10000, (i) => i % 256);
      final hash = SHA256.hashBytes(Uint8List.fromList(largeData));
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Zero bytes handling', () {
      final zeroBytes = Uint8List(100);
      final hash = SHA256.hashBytes(zeroBytes);
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Single byte handling', () {
      final singleByte = Uint8List.fromList([65]); // 'A'
      final hash = SHA256.hashBytes(singleByte);
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Boundary conditions', () {
      // Test with exactly 55 bytes (one byte short of needing padding)
      final boundaryData = Uint8List.fromList(
        List.generate(55, (i) => i % 256),
      );
      final hash = SHA256.hashBytes(boundaryData);
      expect(hash.length, 64);

      // Test with exactly 56 bytes (exactly fits in one block)
      final boundaryData2 = Uint8List.fromList(
        List.generate(56, (i) => i % 256),
      );
      final hash2 = SHA256.hashBytes(boundaryData2);
      expect(hash2.length, 64);
    });

    test('Performance test', () {
      final stopwatch = Stopwatch();
      final testData = 'Performance test data';

      stopwatch.start();
      for (int i = 0; i < 1000; i++) {
        SHA256.hash('$testData$i');
      }
      stopwatch.stop();

      // Should complete 1000 hashes in reasonable time (less than 1 second)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('Memory usage test', () {
      final largeInput = 'A' * 100000;
      final before = ProcessInfo.currentRss;

      SHA256.hash(largeInput);

      final after = ProcessInfo.currentRss;
      final memoryIncrease = after - before;

      // Memory increase should be reasonable for large data processing
      // SHA-256 processes data in 512-bit blocks, so some memory allocation is expected
      // For 100KB input, we expect reasonable memory usage (less than 10MB)
      expect(memoryIncrease, lessThan(10 * 1024 * 1024));
    });
  });
}
