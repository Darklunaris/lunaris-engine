/// 🌸 Bloom Filter Example - Demonstrating High-Performance Data Filtering
///
/// This example showcases the production-ready Bloom Filter implementation with
/// various use cases including web caching, database query optimization,
/// network packet filtering, and large-scale data deduplication.
///
/// Example:
/// ```bash
/// dart run example/bloom_filter_example.dart
/// ```
library;

import 'dart:math';
import 'package:lunaris_engine/Set/bloom_filter.dart';

void main() {
  print('🌸 Bloom Filter Examples\n');

  // Example 1: Basic Bloom Filter Operations
  print('=== Example 1: Basic Bloom Filter Operations ===');
  _demonstrateBasicOperations();

  // Example 2: Web Cache Optimization
  print('\n=== Example 2: Web Cache Optimization ===');
  _demonstrateWebCache();

  // Example 3: Database Query Optimization
  print('\n=== Example 3: Database Query Optimization ===');
  _demonstrateDatabaseOptimization();

  // Example 4: Network Packet Filtering
  print('\n=== Example 4: Network Packet Filtering ===');
  _demonstrateNetworkFiltering();

  // Example 5: Large-Scale Deduplication
  print('\n=== Example 5: Large-Scale Deduplication ===');
  _demonstrateDeduplication();

  // Example 6: Performance and False Positive Analysis
  print('\n=== Example 6: Performance and False Positive Analysis ===');
  _demonstratePerformanceAnalysis();

  // Example 7: Custom Configurations
  print('\n=== Example 7: Custom Configurations ===');
  _demonstrateCustomConfigurations();

  print('\n✅ All Bloom Filter examples completed successfully!');
}

/// Demonstrates basic Bloom filter operations
void _demonstrateBasicOperations() {
  print(
    'Creating Bloom filter with 1000 expected elements and 1% false positive rate...',
  );

  // Create optimal Bloom filter
  final bloomFilter = BloomFilter<String>.optimal(
    expectedElements: 1000,
    falsePositiveRate: 0.01,
  );

  print('Bloom filter created successfully!');
  print('  - Configuration: ${bloomFilter.config}');
  print('  - Current elements: ${bloomFilter.elementCount}');
  print(
    '  - Estimated false positive rate: ${(bloomFilter.estimatedFalsePositiveRate * 100).toStringAsFixed(2)}%',
  );

  // Add elements
  final elements = ['user123', 'user456', 'user789', 'admin', 'guest'];
  bloomFilter.addAll(elements);

  print('  - Added ${elements.length} elements');
  print('  - Current elements: ${bloomFilter.elementCount}');
  print(
    '  - Bit density: ${(bloomFilter.bitDensity * 100).toStringAsFixed(2)}%',
  );

  // Test membership
  for (final element in elements) {
    final exists = bloomFilter.contains(element);
    print('  - "$element" exists: $exists');
  }

  // Test non-existent elements
  final nonExistent = ['user999', 'unknown', 'test'];
  for (final element in nonExistent) {
    final exists = bloomFilter.contains(element);
    print('  - "$element" exists: $exists (false positive possible)');
  }
}

/// Demonstrates web cache optimization scenario
void _demonstrateWebCache() {
  print('Simulating web cache optimization...');

  // Create Bloom filter for URL cache
  final urlCache = BloomFilter<String>.optimal(
    expectedElements: 10000,
    falsePositiveRate: 0.005, // 0.5% false positive rate
  );

  // Simulate popular URLs being cached
  final popularUrls = [
    'https://example.com/home',
    'https://example.com/about',
    'https://example.com/contact',
    'https://example.com/products',
    'https://example.com/blog',
  ];

  urlCache.addAll(popularUrls);
  print('  - Added ${popularUrls.length} popular URLs to cache');

  // Simulate incoming requests
  final incomingRequests = [
    'https://example.com/home', // Should be in cache
    'https://example.com/about', // Should be in cache
    'https://example.com/new-page', // Not in cache
    'https://example.com/contact', // Should be in cache
    'https://example.com/unknown', // Not in cache
  ];

  int cacheHits = 0;
  int cacheMisses = 0;

  for (final url in incomingRequests) {
    if (urlCache.contains(url)) {
      cacheHits++;
      print('  - Cache HIT: $url');
    } else {
      cacheMisses++;
      print('  - Cache MISS: $url');
    }
  }

  print('  - Cache performance: $cacheHits hits, $cacheMisses misses');
  print(
    '  - Hit rate: ${(cacheHits / incomingRequests.length * 100).toStringAsFixed(1)}%',
  );
  print(
    '  - Current false positive rate: ${(urlCache.estimatedFalsePositiveRate * 100).toStringAsFixed(3)}%',
  );
}

/// Demonstrates database query optimization
void _demonstrateDatabaseOptimization() {
  print('Simulating database query optimization...');

  // Create Bloom filter for user IDs
  final userFilter = BloomFilter<int>.optimal(
    expectedElements: 50000,
    falsePositiveRate: 0.001, // 0.1% false positive rate
  );

  // Simulate existing user IDs
  final existingUsers = List.generate(10000, (i) => i + 1000);
  userFilter.addAll(existingUsers);

  print('  - Added ${existingUsers.length} existing user IDs');
  print('  - Filter configuration: ${userFilter.config}');

  // Simulate database queries
  final queryIds = [1001, 2000, 5000, 9999, 15000, 25000, 99999];

  for (final id in queryIds) {
    final exists = userFilter.contains(id);
    final actualExists = existingUsers.contains(id);

    if (exists && actualExists) {
      print('  - User $id: TRUE POSITIVE - User exists');
    } else if (!exists && !actualExists) {
      print('  - User $id: TRUE NEGATIVE - User does not exist');
    } else if (exists && !actualExists) {
      print('  - User $id: FALSE POSITIVE - Filter error (expected)');
    } else {
      print('  - User $id: FALSE NEGATIVE - Filter error (unexpected)');
    }
  }

  // Calculate accuracy metrics
  int truePositives = 0;
  int trueNegatives = 0;
  int falsePositives = 0;
  int falseNegatives = 0;

  for (final id in queryIds) {
    final exists = userFilter.contains(id);
    final actualExists = existingUsers.contains(id);

    if (exists && actualExists) {
      truePositives++;
    } else if (!exists && !actualExists) {
      trueNegatives++;
    } else if (exists && !actualExists) {
      falsePositives++;
    } else {
      falseNegatives++;
    }
  }

  final total = queryIds.length;
  final accuracy = (truePositives + trueNegatives) / total;
  final precision = truePositives / (truePositives + falsePositives);
  final recall = truePositives / (truePositives + falseNegatives);

  print('  - Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%');
  print('  - Precision: ${(precision * 100).toStringAsFixed(1)}%');
  print('  - Recall: ${(recall * 100).toStringAsFixed(1)}%');
}

/// Demonstrates network packet filtering
void _demonstrateNetworkFiltering() {
  print('Simulating network packet filtering...');

  // Create Bloom filter for blocked IP addresses
  final blockedIPs = BloomFilter<String>.optimal(
    expectedElements: 1000,
    falsePositiveRate: 0.02, // 2% false positive rate
  );

  // Simulate blocked IP addresses
  final blockedAddresses = [
    '192.168.1.100',
    '10.0.0.50',
    '172.16.0.25',
    '203.0.113.10',
    '198.51.100.5',
  ];

  blockedIPs.addAll(blockedAddresses);
  print('  - Added ${blockedAddresses.length} blocked IP addresses');

  // Simulate incoming packets
  final incomingPackets = [
    '192.168.1.100', // Should be blocked
    '192.168.1.101', // Should not be blocked
    '10.0.0.50', // Should be blocked
    '8.8.8.8', // Should not be blocked
    '172.16.0.25', // Should be blocked
    '1.1.1.1', // Should not be blocked
  ];

  int blocked = 0;
  int allowed = 0;

  for (final ip in incomingPackets) {
    if (blockedIPs.contains(ip)) {
      blocked++;
      print('  - BLOCKED: $ip');
    } else {
      allowed++;
      print('  - ALLOWED: $ip');
    }
  }

  print('  - Packet filtering results: $blocked blocked, $allowed allowed');
  print(
    '  - Current false positive rate: ${(blockedIPs.estimatedFalsePositiveRate * 100).toStringAsFixed(2)}%',
  );
}

/// Demonstrates large-scale deduplication
void _demonstrateDeduplication() {
  print('Simulating large-scale data deduplication...');

  // Create Bloom filter for large dataset
  final dedupFilter = BloomFilter<String>.optimal(
    expectedElements: 100000,
    falsePositiveRate: 0.001, // 0.1% false positive rate
  );

  // Simulate data stream with duplicates
  final random = Random(42); // Fixed seed for reproducible results
  final dataStream = <String>[];

  // Generate data with known duplicates
  for (int i = 0; i < 50000; i++) {
    final value = 'data_${random.nextInt(100000)}';
    dataStream.add(value);
  }

  print('  - Generated data stream with ${dataStream.length} items');
  print(
    '  - Expected unique items: ~${(dataStream.length * 0.63).round()} (based on birthday paradox)',
  );

  // Process data stream
  int uniqueItems = 0;
  int duplicateItems = 0;
  int falsePositives = 0;

  final seenItems = <String>{};

  for (final item in dataStream) {
    if (dedupFilter.contains(item)) {
      duplicateItems++;
    } else {
      dedupFilter.add(item);
      uniqueItems++;

      // Check for false positives
      if (seenItems.contains(item)) {
        falsePositives++;
      }
      seenItems.add(item);
    }
  }

  print('  - Deduplication results:');
  print('    • Unique items: $uniqueItems');
  print('    • Duplicate items: $duplicateItems');
  print('    • False positives: $falsePositives');
  print('    • Actual unique items: ${seenItems.length}');
  print(
    '    • False positive rate: ${(falsePositives / seenItems.length * 100).toStringAsFixed(3)}%',
  );
  print(
    '    • Estimated false positive rate: ${(dedupFilter.estimatedFalsePositiveRate * 100).toStringAsFixed(3)}%',
  );
}

/// Demonstrates performance and false positive analysis
void _demonstratePerformanceAnalysis() {
  print('Analyzing Bloom filter performance characteristics...');

  // Test different configurations
  final configurations = [
    {'elements': 1000, 'falsePositiveRate': 0.01},
    {'elements': 10000, 'falsePositiveRate': 0.01},
    {'elements': 100000, 'falsePositiveRate': 0.01},
    {'elements': 10000, 'falsePositiveRate': 0.001},
    {'elements': 10000, 'falsePositiveRate': 0.1},
  ];

  for (final config in configurations) {
    final elements = config['elements'] as int;
    final falsePositiveRate = config['falsePositiveRate'] as double;

    print(
      '  - Testing configuration: $elements elements, ${(falsePositiveRate * 100).toStringAsFixed(1)}% false positive rate',
    );

    // Create filter
    final startTime = DateTime.now();
    final filter = BloomFilter<String>.optimal(
      expectedElements: elements,
      falsePositiveRate: falsePositiveRate,
    );
    final creationTime = DateTime.now().difference(startTime);

    print('    • Creation time: ${creationTime.inMicroseconds}μs');
    print('    • Optimal size: ${filter.config.optimalSize} bits');
    print('    • Hash functions: ${filter.config.optimalHashFunctions}');

    // Performance test
    final testData = List.generate(1000, (i) => 'test_item_$i');

    // Add performance
    final addStartTime = DateTime.now();
    filter.addAll(testData);
    final addTime = DateTime.now().difference(addStartTime);

    // Query performance
    final queryStartTime = DateTime.now();
    for (final item in testData) {
      filter.contains(item);
    }
    final queryTime = DateTime.now().difference(queryStartTime);

    print('    • Add 1000 items: ${addTime.inMicroseconds}μs');
    print('    • Query 1000 items: ${queryTime.inMicroseconds}μs');
    print(
      '    • Average add time: ${(addTime.inMicroseconds / 1000).toStringAsFixed(2)}μs/item',
    );
    print(
      '    • Average query time: ${(queryTime.inMicroseconds / 1000).toStringAsFixed(2)}μs/item',
    );
    print(
      '    • Current false positive rate: ${(filter.estimatedFalsePositiveRate * 100).toStringAsFixed(3)}%',
    );
  }
}

/// Demonstrates custom configurations
void _demonstrateCustomConfigurations() {
  print('Demonstrating custom Bloom filter configurations...');

  // Custom configuration for specific use case
  final customFilter = BloomFilter<String>.custom(
    size: 5000,
    hashFunctions: 7,
    seeds: [
      0x12345678,
      0x87654321,
      0xDEADBEEF,
      0xCAFEBABE,
      0x1337C0DE,
      0xDEADC0DE,
      0xBABECAFE,
    ],
  );

  print('  - Custom filter created:');
  print('    • Size: ${customFilter.config.optimalSize} bits');
  print('    • Hash functions: ${customFilter.config.optimalHashFunctions}');
  print('    • Seeds: ${customFilter.config.seeds.length} custom seeds');

  // Test with custom data
  final customData = ['custom_item_1', 'custom_item_2', 'custom_item_3'];
  customFilter.addAll(customData);

  print('  - Added custom data: $customData');
  print('  - Current elements: ${customFilter.elementCount}');
  print(
    '  - Bit density: ${(customFilter.bitDensity * 100).toStringAsFixed(2)}%',
  );

  // Test membership
  for (final item in customData) {
    final exists = customFilter.contains(item);
    print('  - "$item" exists: $exists');
  }

  // Test union operation
  final otherFilter = BloomFilter<String>.custom(size: 5000, hashFunctions: 7);
  otherFilter.addAll(['other_item_1', 'other_item_2']);

  final unionFilter = customFilter.union(otherFilter);
  print('  - Union filter created with ${unionFilter.elementCount} elements');

  // Test intersection operation
  final intersectionFilter = customFilter.intersection(otherFilter);
  print(
    '  - Intersection filter created with ${intersectionFilter.elementCount} elements',
  );

  // Serialization test
  final json = customFilter.toJson();
  final reconstructedFilter = BloomFilter<String>.fromJson(json);

  print('  - Serialization test:');
  print('    • Original elements: ${customFilter.elementCount}');
  print('    • Reconstructed elements: ${reconstructedFilter.elementCount}');
  print(
    '    • Serialization successful: ${customFilter.elementCount == reconstructedFilter.elementCount}',
  );
}
