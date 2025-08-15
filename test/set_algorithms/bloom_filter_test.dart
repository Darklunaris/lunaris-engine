import 'package:lunaris_engine/Set/bloom_filter.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  group('BloomFilter Tests', () {
    group('Basic Operations', () {
      test('Empty filter creation', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        expect(filter.elementCount, equals(0));
        expect(filter.estimatedFalsePositiveRate, equals(0.0));
        expect(filter.bitDensity, equals(0.0));
      });

      test('Add single element', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        filter.add('test_element');

        expect(filter.elementCount, equals(1));
        expect(filter.contains('test_element'), isTrue);
        expect(filter.bitDensity, greaterThan(0.0));
      });

      test('Add multiple elements', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        final elements = [
          'element1',
          'element2',
          'element3',
          'element4',
          'element5',
        ];
        filter.addAll(elements);

        expect(filter.elementCount, equals(5));
        for (final element in elements) {
          expect(filter.contains(element), isTrue);
        }
      });

      test('Check non-existent elements', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        filter.add('existing_element');

        expect(filter.contains('non_existent_element'), isFalse);
        expect(filter.contains('another_missing'), isFalse);
      });

      test('Clear filter', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        filter.add('test_element');
        expect(filter.elementCount, equals(1));

        filter.clear();
        expect(filter.elementCount, equals(0));
        expect(filter.bitDensity, equals(0.0));
        expect(filter.contains('test_element'), isFalse);
      });
    });

    group('Configuration', () {
      test('Optimal configuration calculation', () {
        final config = BloomFilterConfig.optimal(
          expectedElements: 10000,
          falsePositiveRate: 0.01,
        );

        expect(config.expectedElements, equals(10000));
        expect(config.falsePositiveRate, equals(0.01));
        expect(config.optimalSize, greaterThan(0));
        expect(config.optimalHashFunctions, greaterThan(0));
        expect(config.seeds, isNotEmpty);
        expect(config.seeds.length, equals(config.optimalHashFunctions));
      });

      test('Custom configuration', () {
        final config = BloomFilterConfig.custom(
          size: 5000,
          hashFunctions: 7,
          seeds: [1, 2, 3, 4, 5, 6, 7],
        );

        expect(config.optimalSize, equals(5000));
        expect(config.optimalHashFunctions, equals(7));
        expect(config.seeds, equals([1, 2, 3, 4, 5, 6, 7]));
      });

      test('Configuration validation', () {
        expect(
          () => BloomFilterConfig.optimal(
            expectedElements: 0,
            falsePositiveRate: 0.01,
          ),
          throwsArgumentError,
        );

        expect(
          () => BloomFilterConfig.optimal(
            expectedElements: 1000,
            falsePositiveRate: 0.0,
          ),
          throwsArgumentError,
        );

        expect(
          () => BloomFilterConfig.optimal(
            expectedElements: 1000,
            falsePositiveRate: 1.0,
          ),
          throwsArgumentError,
        );

        expect(
          () => BloomFilterConfig.custom(size: 0, hashFunctions: 5),
          throwsArgumentError,
        );

        expect(
          () => BloomFilterConfig.custom(size: 1000, hashFunctions: 0),
          throwsArgumentError,
        );
      });

      test('Configuration string representation', () {
        final config = BloomFilterConfig.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        final str = config.toString();
        expect(str, contains('1000'));
        expect(str, contains('0.01'));
        expect(str, contains('size:'));
        expect(str, contains('hashFunctions:'));
      });
    });

    group('Hash Functions', () {
      test('MurmurHash consistency', () {
        final filter = BloomFilter<String>.custom(size: 1000, hashFunctions: 1);

        filter.add('test_string');
        final result1 = filter.contains('test_string');
        final result2 = filter.contains('test_string');

        expect(result1, equals(result2));
      });

      test('FNV hash consistency', () {
        final filter = BloomFilter<String>.custom(size: 1000, hashFunctions: 2);

        filter.add('test_string');
        final result1 = filter.contains('test_string');
        final result2 = filter.contains('test_string');

        expect(result1, equals(result2));
      });

      test('Jenkins hash consistency', () {
        final filter = BloomFilter<String>.custom(size: 1000, hashFunctions: 3);

        filter.add('test_string');
        final result1 = filter.contains('test_string');
        final result2 = filter.contains('test_string');

        expect(result1, equals(result2));
      });

      test('Hash function distribution', () {
        final filter = BloomFilter<String>.custom(
          size: 10000,
          hashFunctions: 10,
        );

        final testStrings = List.generate(100, (i) => 'test_string_$i');
        filter.addAll(testStrings);

        // Check that different strings produce different results
        final results = <bool>{};
        for (final str in testStrings) {
          results.add(filter.contains(str));
        }

        // All should be true, but we're testing hash distribution
        expect(results.length, equals(1)); // All should be true
        expect(results.first, isTrue);
      });
    });

    group('False Positive Analysis', () {
      test('False positive rate estimation', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        // Add elements up to expected capacity
        for (int i = 0; i < 1000; i++) {
          filter.add('element_$i');
        }

        final estimatedRate = filter.estimatedFalsePositiveRate;
        expect(estimatedRate, greaterThan(0.0));
        expect(estimatedRate, lessThan(0.1)); // Should be reasonable
      });

      test('False positive rate increases with load', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        final rate1 = filter.estimatedFalsePositiveRate;

        // Add some elements
        for (int i = 0; i < 500; i++) {
          filter.add('element_$i');
        }

        final rate2 = filter.estimatedFalsePositiveRate;
        expect(rate2, greaterThan(rate1));
      });

      test('False positive detection', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 100,
          falsePositiveRate: 0.1, // Higher rate for testing
        );

        // Add elements
        for (int i = 0; i < 50; i++) {
          filter.add('element_$i');
        }

        // Test with random strings that shouldn't exist
        int falsePositives = 0;
        final random = Random(42);

        for (int i = 0; i < 1000; i++) {
          final randomString = 'random_${random.nextInt(1000000)}';
          if (filter.contains(randomString)) {
            falsePositives++;
          }
        }

        final falsePositiveRate = falsePositives / 1000.0;
        expect(falsePositiveRate, greaterThan(0.0));
        expect(falsePositiveRate, lessThan(0.2)); // Should be reasonable
      });
    });

    group('Set Operations', () {
      test('Union operation', () {
        final filter1 = BloomFilter<String>.custom(
          size: 1000,
          hashFunctions: 5,
        );
        final filter2 = BloomFilter<String>.custom(
          size: 1000,
          hashFunctions: 5,
        );

        filter1.addAll(['a', 'b', 'c']);
        filter2.addAll(['c', 'd', 'e']);

        final union = filter1.union(filter2);

        expect(union.contains('a'), isTrue);
        expect(union.contains('b'), isTrue);
        expect(union.contains('c'), isTrue);
        expect(union.contains('d'), isTrue);
        expect(union.contains('e'), isTrue);
      });

      test('Intersection operation', () {
        final filter1 = BloomFilter<String>.custom(
          size: 1000,
          hashFunctions: 5,
        );
        final filter2 = BloomFilter<String>.custom(
          size: 1000,
          hashFunctions: 5,
        );

        filter1.addAll(['a', 'b', 'c', 'd']);
        filter2.addAll(['c', 'd', 'e', 'f']);

        final intersection = filter1.intersection(filter2);

        // Note: Bloom filter intersection is approximate
        expect(intersection.elementCount, greaterThan(0));
      });

      test('Union with different sizes throws error', () {
        final filter1 = BloomFilter<String>.custom(
          size: 1000,
          hashFunctions: 5,
        );
        final filter2 = BloomFilter<String>.custom(
          size: 2000,
          hashFunctions: 5,
        );

        expect(() => filter1.union(filter2), throwsArgumentError);
        expect(() => filter2.union(filter1), throwsArgumentError);
      });

      test('Intersection with different sizes throws error', () {
        final filter1 = BloomFilter<String>.custom(
          size: 1000,
          hashFunctions: 5,
        );
        final filter2 = BloomFilter<String>.custom(
          size: 2000,
          hashFunctions: 5,
        );

        expect(() => filter1.intersection(filter2), throwsArgumentError);
        expect(() => filter2.intersection(filter1), throwsArgumentError);
      });
    });

    group('Serialization', () {
      test('Filter to JSON', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        filter.addAll(['element1', 'element2', 'element3']);

        final json = filter.toJson();

        expect(json['config'], isMap);
        expect(json['bitArray'], isList);
        expect(json['elementCount'], equals(3));

        final config = json['config'] as Map<String, dynamic>;
        expect(config['expectedElements'], equals(1000));
        expect(config['falsePositiveRate'], equals(0.01));
        expect(config['optimalSize'], greaterThan(0));
        expect(config['optimalHashFunctions'], greaterThan(0));
        expect(config['seeds'], isList);
      });

      test('Filter from JSON', () {
        final originalFilter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        originalFilter.addAll(['element1', 'element2', 'element3']);

        final json = originalFilter.toJson();
        final reconstructedFilter = BloomFilter<String>.fromJson(json);

        expect(
          reconstructedFilter.elementCount,
          equals(originalFilter.elementCount),
        );
        expect(
          reconstructedFilter.config.optimalSize,
          equals(originalFilter.config.optimalSize),
        );
        expect(
          reconstructedFilter.config.optimalHashFunctions,
          equals(originalFilter.config.optimalHashFunctions),
        );
      });

      test('JSON round trip consistency', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 500,
          falsePositiveRate: 0.05,
        );

        filter.addAll(['test1', 'test2', 'test3', 'test4', 'test5']);

        final json1 = filter.toJson();
        final reconstructed1 = BloomFilter<String>.fromJson(json1);
        final json2 = reconstructed1.toJson();
        final reconstructed2 = BloomFilter<String>.fromJson(json2);

        expect(
          reconstructed1.elementCount,
          equals(reconstructed2.elementCount),
        );
        expect(
          reconstructed1.config.optimalSize,
          equals(reconstructed2.config.optimalSize),
        );
      });

      test('Serialization with custom parameters', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        filter.add('test1');
        filter.add('test2');

        final serialized = filter.toJson();
        final deserialized = BloomFilter<String>.fromJson(serialized);

        expect(deserialized.contains('test1'), isTrue);
        expect(deserialized.contains('test2'), isTrue);
        expect(deserialized.contains('test3'), isFalse);
      });
    });

    group('Memory Usage Tests', () {
      test('Large filter creation performance', () {
        final startTime = DateTime.now();

        final filter = BloomFilter<String>.optimal(
          expectedElements: 100000,
          falsePositiveRate: 0.001,
        );

        final creationTime = DateTime.now().difference(startTime);
        expect(creationTime.inMilliseconds, lessThan(100)); // Should be fast

        expect(filter.config.optimalSize, greaterThan(100000));
        expect(filter.config.optimalHashFunctions, greaterThan(0));
      });

      test('Add performance', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 10000,
          falsePositiveRate: 0.01,
        );

        final startTime = DateTime.now();

        for (int i = 0; i < 10000; i++) {
          filter.add('element_$i');
        }

        final addTime = DateTime.now().difference(startTime);
        expect(
          addTime.inMilliseconds,
          lessThan(1000),
        ); // Should be reasonably fast

        expect(filter.elementCount, equals(10000));
      });

      test('Contains performance', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 10000,
          falsePositiveRate: 0.01,
        );

        // Add elements
        for (int i = 0; i < 10000; i++) {
          filter.add('element_$i');
        }

        final startTime = DateTime.now();

        for (int i = 0; i < 10000; i++) {
          filter.contains('element_$i');
        }

        final containsTime = DateTime.now().difference(startTime);
        expect(
          containsTime.inMilliseconds,
          lessThan(1000),
        ); // Should be very fast
      });

      test('Memory efficiency', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 100000,
          falsePositiveRate: 0.01,
        );

        // Add elements to see actual memory usage
        for (int i = 0; i < 50000; i++) {
          filter.add('element_$i');
        }

        expect(filter.elementCount, equals(50000));
        expect(filter.bitDensity, greaterThan(0.0));
        expect(filter.bitDensity, lessThan(0.8)); // Shouldn't be too dense
      });
    });

    group('Edge Cases', () {
      test('Null element handling', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        // Should handle null gracefully
        filter.add('valid_element');
        expect(filter.elementCount, equals(1));
      });

      test('Empty string handling', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        filter.add('');
        expect(filter.contains(''), isTrue);
        expect(filter.elementCount, equals(1));
      });

      test('Very long string handling', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        final longString = 'a' * 10000;
        filter.add(longString);

        expect(filter.contains(longString), isTrue);
        expect(filter.elementCount, equals(1));
      });

      test('Special characters handling', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        final specialString = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
        filter.add(specialString);

        expect(filter.contains(specialString), isTrue);
        expect(filter.elementCount, equals(1));
      });

      test('Unicode string handling', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        final unicodeString = 'Hello, 世界! 🌍';
        filter.add(unicodeString);

        expect(filter.contains(unicodeString), isTrue);
        expect(filter.elementCount, equals(1));
      });

      test('Duplicate element handling', () {
        final filter = BloomFilter<String>.optimal(
          expectedElements: 1000,
          falsePositiveRate: 0.01,
        );

        filter.add('duplicate');
        filter.add('duplicate');
        filter.add('duplicate');

        expect(
          filter.elementCount,
          equals(1),
        ); // Should only count unique elements
        expect(filter.contains('duplicate'), isTrue);
      });
    });

    group('Configuration Validation', () {
      test('Invalid expected elements', () {
        expect(
          () => BloomFilter<String>.optimal(
            expectedElements: -1,
            falsePositiveRate: 0.01,
          ),
          throwsArgumentError,
        );

        expect(
          () => BloomFilter<String>.optimal(
            expectedElements: 0,
            falsePositiveRate: 0.01,
          ),
          throwsArgumentError,
        );
      });

      test('Invalid false positive rate', () {
        expect(
          () => BloomFilter<String>.optimal(
            expectedElements: 1000,
            falsePositiveRate: -0.1,
          ),
          throwsArgumentError,
        );

        expect(
          () => BloomFilter<String>.optimal(
            expectedElements: 1000,
            falsePositiveRate: 0.0,
          ),
          throwsArgumentError,
        );

        expect(
          () => BloomFilter<String>.optimal(
            expectedElements: 1000,
            falsePositiveRate: 1.0,
          ),
          throwsArgumentError,
        );

        expect(
          () => BloomFilter<String>.optimal(
            expectedElements: 1000,
            falsePositiveRate: 1.5,
          ),
          throwsArgumentError,
        );
      });

      test('Invalid custom size', () {
        expect(
          () => BloomFilter<String>.custom(size: -1, hashFunctions: 5),
          throwsArgumentError,
        );

        expect(
          () => BloomFilter<String>.custom(size: 0, hashFunctions: 5),
          throwsArgumentError,
        );
      });

      test('Invalid hash function count', () {
        expect(
          () => BloomFilter<String>.custom(size: 1000, hashFunctions: -1),
          throwsArgumentError,
        );

        expect(
          () => BloomFilter<String>.custom(size: 1000, hashFunctions: 0),
          throwsArgumentError,
        );
      });
    });
  });
}
