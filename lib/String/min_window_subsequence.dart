/// Finds the minimum window in string [s] that contains string [t] as a subsequence.
///
/// This function returns the smallest substring of [s] that contains all characters of [t] in order (as a subsequence).
/// If no such window exists, returns an empty string.
///
/// Time Complexity: O(m * n), where m is the length of [s] and n is the length of [t].
/// Space Complexity: O(1)
///
/// Example:
/// ```dart
/// String s = "abcdebdde";
/// String t = "bde";
/// print(minWindowSubsequence(s, t)); // Outputs: "bcde"
/// ```
String minWindowSubsequence(String s, String t) {
  int m = s.length, n = t.length;
  int minLen = m + 1, start = -1;
  for (int i = 0, j = 0; i < m; i++) {
    if (s[i] == t[j]) {
      j++;
      if (j == n) {
        int end = i + 1;
        j--;
        int k = i;
        while (j >= 0) {
          if (s[k] == t[j]) j--;
          k--;
        }
        k++;
        if (end - k < minLen) {
          minLen = end - k;
          start = k;
        }
        j = 0;
      }
    }
  }
  return start == -1 ? '' : s.substring(start, start + minLen);
}
