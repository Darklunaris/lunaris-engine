import 'package:lunaris_engine/Cryptographic/scrypt_mining.dart';
import 'package:test/test.dart';
import 'dart:typed_data';
import 'dart:io';

void main() {
  group('ScryptMining Tests', () {
    test('Empty block header hash', () {
      final params = ScryptMiningParams.litecoinMainnet(
        blockHeader: Uint8List(0),
        salt: Uint8List.fromList([1, 2, 3, 4]),
      );

      final hash = ScryptMining.hash(params);
      expect(hash.length, 64); // 32 bytes = 64 hex characters
      expect(hash, isA<String>());
    });

    test('Simple block header hash', () {
      final blockHeader = Uint8List.fromList('TestBlockHeader'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);

      final params = ScryptMiningParams.litecoinMainnet(
        blockHeader: blockHeader,
        salt: salt,
      );

      final hash = ScryptMining.hash(params);
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Long block header hash', () {
      final longHeader = Uint8List.fromList(
        List.generate(1000, (i) => 65),
      ); // 'A' repeated 1000 times
      final salt = Uint8List.fromList(List.generate(16, (i) => i));

      final params = ScryptMiningParams.litecoinMainnet(
        blockHeader: longHeader,
        salt: salt,
      );

      final hash = ScryptMining.hash(params);
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Raw hash parameters', () {
      final blockHeader = Uint8List.fromList('TestBlock'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      final hash = ScryptMining.hashRaw(
        blockHeader,
        salt,
        N: 1024,
        r: 1,
        p: 1,
        dkLen: 32,
      );

      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Raw hash bytes', () {
      final blockHeader = Uint8List.fromList('TestBlock'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      final params = ScryptMiningParams.litecoinMainnet(
        blockHeader: blockHeader,
        salt: salt,
      );

      final hashBytes = ScryptMining.hashRawBytes(params);
      expect(hashBytes.length, 32); // 32 bytes output
      expect(hashBytes, isA<Uint8List>());
    });

    test('Consistent hashing', () {
      final blockHeader = Uint8List.fromList('ConsistentTest'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      final params = ScryptMiningParams.litecoinMainnet(
        blockHeader: blockHeader,
        salt: salt,
      );

      final hash1 = ScryptMining.hash(params);
      final hash2 = ScryptMining.hash(params);
      expect(hash1, equals(hash2));
    });

    test('Different inputs produce different hashes', () {
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      final params1 = ScryptMiningParams.litecoinMainnet(
        blockHeader: Uint8List.fromList('input1'.codeUnits),
        salt: salt,
      );

      final params2 = ScryptMiningParams.litecoinMainnet(
        blockHeader: Uint8List.fromList('input2'.codeUnits),
        salt: salt,
      );

      final hash1 = ScryptMining.hash(params1);
      final hash2 = ScryptMining.hash(params2);
      expect(hash1, isNot(equals(hash2)));
    });

    test('Different salts produce different hashes', () {
      final blockHeader = Uint8List.fromList('TestBlock'.codeUnits);

      // Use significantly different salts
      final salt1 = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
      final salt2 = Uint8List.fromList([
        255,
        254,
        253,
        252,
        251,
        250,
        249,
        248,
      ]);

      final params1 = ScryptMiningParams.litecoinMainnet(
        blockHeader: blockHeader,
        salt: salt1,
      );

      final params2 = ScryptMiningParams.litecoinMainnet(
        blockHeader: blockHeader,
        salt: salt2,
      );

      final hash1 = ScryptMining.hash(params1);
      final hash2 = ScryptMining.hash(params2);

      // Debug output
      print(
        'Salt 1: ${salt1.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
      );
      print(
        'Salt 2: ${salt2.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
      );
      print('Hash 1: $hash1');
      print('Hash 2: $hash2');

      expect(hash1, isNot(equals(hash2)));
    });

    test('Hash avalanche effect', () {
      final blockHeader1 = Uint8List.fromList('Hello, World!'.codeUnits);
      final blockHeader2 = Uint8List.fromList('Hello, World?'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      final params1 = ScryptMiningParams.litecoinMainnet(
        blockHeader: blockHeader1,
        salt: salt,
      );

      final params2 = ScryptMiningParams.litecoinMainnet(
        blockHeader: blockHeader2,
        salt: salt,
      );

      final hash1 = ScryptMining.hash(params1);
      final hash2 = ScryptMining.hash(params2);

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
      final largeData = Uint8List.fromList(
        List.generate(10000, (i) => i % 256),
      );
      final salt = Uint8List.fromList(List.generate(16, (i) => i));

      final params = ScryptMiningParams.litecoinMainnet(
        blockHeader: largeData,
        salt: salt,
      );

      final hash = ScryptMining.hash(params);
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Zero bytes handling', () {
      final zeroBytes = Uint8List(100);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      final params = ScryptMiningParams.litecoinMainnet(
        blockHeader: zeroBytes,
        salt: salt,
      );

      final hash = ScryptMining.hash(params);
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Single byte handling', () {
      final singleByte = Uint8List.fromList([65]); // 'A'
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      final params = ScryptMiningParams.litecoinMainnet(
        blockHeader: singleByte,
        salt: salt,
      );

      final hash = ScryptMining.hash(params);
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Litecoin testnet parameters', () {
      final blockHeader = Uint8List.fromList('TestnetBlock'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      final params = ScryptMiningParams.litecoinTestnet(
        blockHeader: blockHeader,
        salt: salt,
      );

      final hash = ScryptMining.hash(params);
      expect(hash.length, 64);
      expect(hash, isA<String>());
    });

    test('Custom parameters validation', () {
      final blockHeader = Uint8List.fromList('CustomBlock'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      // Valid custom parameters
      final validParams = ScryptMiningParams.custom(
        N: 2048,
        r: 2,
        p: 2,
        dkLen: 64,
        salt: salt,
        password: blockHeader,
      );

      final hash = ScryptMining.hash(validParams);
      expect(hash.length, 128); // 64 bytes = 128 hex characters
      expect(hash, isA<String>());
    });

    test('Invalid N parameter throws error', () {
      final blockHeader = Uint8List.fromList('InvalidBlock'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      expect(() {
        ScryptMiningParams.custom(
          N: 3, // Not a power of 2
          r: 1,
          p: 1,
          dkLen: 32,
          salt: salt,
          password: blockHeader,
        );
      }, throwsArgumentError);
    });

    test('Invalid r parameter throws error', () {
      final blockHeader = Uint8List.fromList('InvalidBlock'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      expect(() {
        ScryptMiningParams.custom(
          N: 1024,
          r: 0, // Must be positive
          p: 1,
          dkLen: 32,
          salt: salt,
          password: blockHeader,
        );
      }, throwsArgumentError);
    });

    test('Invalid p parameter throws error', () {
      final blockHeader = Uint8List.fromList('InvalidBlock'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      expect(() {
        ScryptMiningParams.custom(
          N: 1024,
          r: 1,
          p: 0, // Must be positive
          dkLen: 32,
          salt: salt,
          password: blockHeader,
        );
      }, throwsArgumentError);
    });

    test('Invalid dkLen parameter throws error', () {
      final blockHeader = Uint8List.fromList('InvalidBlock'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      expect(() {
        ScryptMiningParams.custom(
          N: 1024,
          r: 1,
          p: 1,
          dkLen: 0, // Must be positive
          salt: salt,
          password: blockHeader,
        );
      }, throwsArgumentError);
    });

    test('Performance test', () {
      final stopwatch = Stopwatch();
      final blockHeader = Uint8List.fromList('PerformanceTest'.codeUnits);
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      final params = ScryptMiningParams.litecoinTestnet(
        // Use testnet for faster testing
        blockHeader: blockHeader,
        salt: salt,
      );

      stopwatch.start();
      for (int i = 0; i < 10; i++) {
        // Reduced iterations for faster testing
        ScryptMining.hash(params);
      }
      stopwatch.stop();

      // Should complete 10 hashes in reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(10000));
    });

    test('Memory usage test', () {
      final largeInput = Uint8List.fromList(
        List.generate(10000, (i) => i % 256),
      );
      final salt = Uint8List.fromList(List.generate(16, (i) => i));

      final params = ScryptMiningParams.litecoinTestnet(
        // Use testnet for lower memory
        blockHeader: largeInput,
        salt: salt,
      );

      final before = ProcessInfo.currentRss;
      ScryptMining.hash(params);
      final after = ProcessInfo.currentRss;
      final memoryIncrease = after - before;

      // Memory increase should be reasonable (less than 100MB for testnet)
      expect(memoryIncrease, lessThan(100 * 1024 * 1024));
    });

    test('Boundary conditions', () {
      final salt = Uint8List.fromList([1, 2, 3, 4]);

      // Test with exactly 1 byte
      final singleByte = Uint8List.fromList([65]);
      final params1 = ScryptMiningParams.litecoinTestnet(
        blockHeader: singleByte,
        salt: salt,
      );
      final hash1 = ScryptMining.hash(params1);
      expect(hash1.length, 64);

      // Test with exactly 64 bytes
      final exactBytes = Uint8List.fromList(List.generate(64, (i) => i % 256));
      final params2 = ScryptMiningParams.litecoinTestnet(
        blockHeader: exactBytes,
        salt: salt,
      );
      final hash2 = ScryptMining.hash(params2);
      expect(hash2.length, 64);
    });
  });
}
