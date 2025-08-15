/// Searches for the first occurrence of a pattern in a text using the Boyer-Moore algorithm.
///
/// This function implements the Boyer-Moore string search algorithm, which is efficient for large texts and patterns.
/// Returns the starting index of the first occurrence of [pattern] in [text], or -1 if not found.
///
/// Time Complexity: Best/Average O(n/m), Worst O(n*m), where n is the length of [text] and m is the length of [pattern].
///
/// Example:
/// ```dart
/// int index = boyerMooreSearch("abacaabadcabacabaabb", "abacab");
/// print(index); // Outputs: 10
/// ```
int boyerMooreSearch(String text, String pattern) {
  if (pattern.isEmpty) return 0;
  final badChar = <String, int>{};
  for (int i = 0; i < pattern.length; i++) {
    badChar[pattern[i]] = i;
  }
  int shift = 0;
  while (shift <= text.length - pattern.length) {
    int j = pattern.length - 1;
    while (j >= 0 && pattern[j] == text[shift + j]) {
      j--;
    }
    if (j < 0) return shift;
    shift += (j - (badChar[text[shift + j]] ?? -1)).clamp(1, pattern.length);
  }
  return -1;
}
