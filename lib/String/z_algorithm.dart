/// Computes the Z-array for pattern matching in string [s] (Z-Algorithm).
///
/// The Z-array at position i is the length of the longest substring starting at i
/// that is also a prefix of [s]. This is the canonical linear-time Z-algorithm.
///
/// Returns a list of Z-values for each position in [s]. For an empty string an
/// empty list is returned.
///
/// Time Complexity: O(n), where n is the length of [s].
List<int> zAlgorithm(String s) {
  final n = s.length;
  if (n == 0) return <int>[];
  final z = List<int>.filled(n, 0);
  for (var i = 1; i < n; i++) {
    var j = 0;
    while (i + j < n && s[j] == s[i + j]) {
      j++;
    }
    z[i] = j;
  }
  return z;
}
