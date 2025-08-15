/// Ranks words in a text by frequency (descending), then lexicographically for ties.
///
/// This function splits the input [text] into words, counts their frequencies, and returns a list of words
/// sorted first by frequency (highest first), then alphabetically for words with the same frequency.
///
/// Time Complexity: O(n + k log k), where n is the number of words and k is the number of unique words.
///
/// Example:
/// ```dart
/// String text = "the quick brown fox jumps over the lazy dog the fox";
/// print(wordFrequencyRanking(text)); // Outputs: ["the", "fox", "brown", "dog", "jumps", "lazy", "over", "quick"]
/// ```
List<String> wordFrequencyRanking(String text) {
  final freq = <String, int>{};
  for (final word in text.split(RegExp(r'\W+'))) {
    if (word.isEmpty) continue;
    freq[word] = (freq[word] ?? 0) + 1;
  }
  final words = freq.keys.toList();
  words.sort(
    (a, b) =>
        freq[b] != freq[a] ? freq[b]!.compareTo(freq[a]!) : a.compareTo(b),
  );
  return words;
}
