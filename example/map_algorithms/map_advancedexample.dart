// import 'package:lunaris_engine/map_algorithms/invert_map.dart';
// import 'package:lunaris_engine/map_algorithms/merge_maps_conflict.dart';
// import 'package:lunaris_engine/map_algorithms/group_anagrams.dart';
// import 'package:lunaris_engine/map_algorithms/word_frequency_ranking.dart';
// import 'package:lunaris_engine/map_algorithms/all_pairs_with_sum.dart';
// import 'package:lunaris_engine/map_algorithms/index_mapping.dart';
// import 'package:lunaris_engine/map_algorithms/mru_cache.dart';
// import 'package:lunaris_engine/map_algorithms/count_pairs_with_diff.dart';
// import 'package:lunaris_engine/map_algorithms/find_subarrays_with_sum.dart';
// import 'package:lunaris_engine/map_algorithms/min_window_substring.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  // Invert Map
  final map = {'a': 1, 'b': 2, 'c': 1};
  print('Invert Map: ${invertMap(map)}'); // {1: 'c', 2: 'b'}

  // Merge Two Maps with Conflict Resolution
  final a = {'x': 1, 'y': 2};
  final b = {'y': 3, 'z': 4};
  final merged = mergeMaps(a, b, (k, v1, v2) => v1 + v2);
  print('Merge Maps: $merged'); // {'x': 1, 'y': 5, 'z': 4}

  // Group Anagrams
  final words = ['eat', 'tea', 'tan', 'ate', 'nat', 'bat'];
  print('Group Anagrams: ${groupAnagrams(words)}');

  // Word Frequency Ranking
  final text = 'the quick brown fox jumps over the lazy dog the quick';
  print('Word Frequency Ranking: ${wordFrequencyRanking(text)}');

  // Find All Pairs with Given Sum
  final nums = [1, 5, 7, -1, 5];
  print('All Pairs with Sum 6: ${allPairsWithSum(nums, 6)}');

  // Index Mapping for Elements
  final list = ['a', 'b', 'a', 'c', 'b', 'a'];
  print('Index Mapping: ${indexMapping(list)}');

  // Most Recent Key Access (MRU Cache)
  final mru = MRUCache<String, int>(2);
  mru.put('a', 1);
  mru.put('b', 2);
  mru.get('a');
  mru.put('c', 3);
  print('MRU Cache: $mru'); // Should evict 'b'

  // Counting Pairs with Specific Difference
  final nums2 = [1, 5, 3, 4, 2];
  print('Count Pairs with Diff 2: ${countPairsWithDiff(nums2, 2)}');

  // Find Subarrays with Given Sum
  final nums3 = [10, 2, -2, -20, 10];
  print('Subarrays with Sum -10: ${findSubarraysWithSum(nums3, -10)}');

  // Minimum Window Substring
  print('Min Window Substring: ${minWindowSubstring("ADOBECODEBANC", "ABC")}');
}
