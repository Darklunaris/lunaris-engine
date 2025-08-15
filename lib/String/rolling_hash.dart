/// Rolling Hash for Substring Matching (Rabin-Karp): Returns all start indices where [pattern] occurs in [text].
/// Uses a rolling hash (Rabin-Karp) to find all start indices where [pattern] occurs in [text].
///
/// Returns a list of all starting indices of [pattern] in [text].
///
/// Time Complexity: O(n + m), where n is the length of [text] and m is the length of [pattern].
///
/// Example:
/// ```dart
/// print(rollingHashSearch("abracadabra", "abra")); // [0, 7]
/// ```
///
List<int> rollingHashSearch(String text, String pattern) {
  if (pattern.isEmpty || pattern.length > text.length) return [];
  const base = 256;
  const mod = 1000000007;
  int patHash = 0, txtHash = 0, h = 1;
  final m = pattern.length, n = text.length;
  for (int i = 0; i < m - 1; i++) {
    h = (h * base) % mod;
  }
  for (int i = 0; i < m; i++) {
    patHash = (base * patHash + pattern.codeUnitAt(i)) % mod;
    txtHash = (base * txtHash + text.codeUnitAt(i)) % mod;
  }
  final result = <int>[];
  for (int i = 0; i <= n - m; i++) {
    if (patHash == txtHash) {
      if (text.substring(i, i + m) == pattern) result.add(i);
    }
    if (i < n - m) {
      txtHash =
          (base * (txtHash - text.codeUnitAt(i) * h) + text.codeUnitAt(i + m)) %
          mod;
      if (txtHash < 0) txtHash += mod;
    }
  }
  return result;
}
