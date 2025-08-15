/// Performs a brute force search of the [pattern] string within the [text] string.
///
/// Returns the starting index of the first occurrence of [pattern] in [text].
/// Returns -1 if [pattern] is not found.
///
/// Time Complexity: O(n * m), where n is length of text and m is length of pattern.
///
/// Example:
/// ```dart
/// int index = bruteForceSearch("hello world", "world");
/// print(index); // 6
/// ```
int bruteForceSearch(String text, String pattern) {
  int n = text.length;
  int m = pattern.length;

  if (m == 0) return 0; // empty pattern matches at index 0

  for (int i = 0; i <= n - m; i++) {
    int j = 0;

    while (j < m && text[i + j] == pattern[j]) {
      j++;
    }

    if (j == m) {
      return i;
    }
  }

  return -1;
}
