/// Builds the Longest Prefix Suffix (LPS) array used in KMP algorithm.
///
/// For each position, LPS indicates the length of the longest proper prefix
/// which is also a suffix for the substring ending at that position.
///
/// Time complexity: O(m), where m is length of the pattern.
List<int> buildLPS(String pattern) {
  int length = 0; // length of the previous longest prefix suffix
  int i = 1;
  List<int> lps = List.filled(pattern.length, 0);

  while (i < pattern.length) {
    if (pattern[i] == pattern[length]) {
      length++;
      lps[i] = length;
      i++;
    } else {
      if (length != 0) {
        length = lps[length - 1];
      } else {
        lps[i] = 0;
        i++;
      }
    }
  }

  return lps;
}

/// Performs KMP search of [pattern] within [text].
///
/// Returns the starting index of the first occurrence of [pattern] in [text].
/// Returns -1 if the pattern is not found.
///
/// Time complexity: O(n), where n is length of text.
///
/// Example:
/// ```dart
/// int index = kmpSearch("abxabcabcaby", "abcaby");
/// print(index); // 6
/// ```
int kmpSearch(String text, String pattern) {
  int n = text.length;
  int m = pattern.length;

  if (m == 0) return 0; // empty pattern matches at index 0

  List<int> lps = buildLPS(pattern);

  int i = 0; // index for text
  int j = 0; // index for pattern

  while (i < n) {
    if (text[i] == pattern[j]) {
      i++;
      j++;
    }

    if (j == m) {
      return i - j; // pattern found at index (i - j)
    } else if (i < n && text[i] != pattern[j]) {
      if (j != 0) {
        j = lps[j - 1];
      } else {
        i++;
      }
    }
  }

  return -1; // pattern not found
}
