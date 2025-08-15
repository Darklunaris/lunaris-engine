/// Groups words that are anagrams of each other.
///
/// This function takes a list of words and groups them into lists of anagrams.
/// Words are grouped together if they contain the same characters in any order.
///
/// Time Complexity: O(n * k log k), where n is the number of words and k is the average word length.
///
/// Example:
/// ```dart
/// var result = groupAnagrams(["eat", "tea", "tan", "ate", "nat", "bat"]);
/// print(result); // Outputs: [[eat, tea, ate], [tan, nat], [bat]]
/// ```
List<List<String>> groupAnagrams(List<String> words) {
  final map = <String, List<String>>{};
  for (final word in words) {
    final key = (word.split('')..sort()).join();
    map.putIfAbsent(key, () => []).add(word);
  }
  return map.values.toList();
}
