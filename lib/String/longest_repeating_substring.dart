/// Finds the longest substring in a string that appears at least twice using binary search and rolling hash.
///
/// This function uses a combination of binary search and Rabin-Karp rolling hash to efficiently find the longest
/// repeating substring in the input string [s].
///
/// Time Complexity: O(n log n), where n is the length of the string.
/// Space Complexity: O(n)
///
/// Example:
/// ```dart
/// String s = "banana";
/// print(longestRepeatingSubstring(s)); // Outputs: "ana"
/// ```
String longestRepeatingSubstring(String s) {
  int n = s.length;
  int left = 1, right = n, resLen = 0, resStart = 0;
  while (left <= right) {
    int len = (left + right) ~/ 2;
    final idx = _search(s, len);
    if (idx != -1) {
      resLen = len;
      resStart = idx;
      left = len + 1;
    } else {
      right = len - 1;
    }
  }
  return s.substring(resStart, resStart + resLen);
}

int _search(String s, int len) {
  final seen = <int, List<int>>{};
  const mod = 1 << 32;
  const base = 256;
  int hash = 0, h = 1;
  for (int i = 0; i < len; i++) {
    hash = (hash * base + s.codeUnitAt(i)) % mod;
    if (i > 0) h = (h * base) % mod;
  }
  seen[hash] = [0];
  for (int i = 1; i <= s.length - len; i++) {
    hash =
        ((hash - s.codeUnitAt(i - 1) * h) * base + s.codeUnitAt(i + len - 1)) %
        mod;
    if (hash < 0) hash += mod;
    if (seen.containsKey(hash)) {
      for (final idx in seen[hash]!) {
        if (s.substring(idx, idx + len) == s.substring(i, i + len)) return i;
      }
    }
    seen.putIfAbsent(hash, () => []).add(i);
  }
  return -1;
}
