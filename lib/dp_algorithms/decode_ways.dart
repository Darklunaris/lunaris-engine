/// 🔐 Decode Ways (number of decodings)
///
/// Given a string of digits, returns the number of ways to decode it where
/// 'A'->1, 'B'->2, ... 'Z'->26. Uses DP with O(n) time and O(1) space.
///
/// Contract:
/// - Input: string `s` containing digits only.
/// - Output: number of decode ways (int). Returns 0 for invalid encodings.
/// - Error modes: non-digit characters undefined behavior (caller responsibility).
///
/// Example:
/// ```dart
/// numDecodings('12'); // 2 ('AB' or 'L')
/// ```
int numDecodings(String s) {
  if (s.isEmpty) return 0;
  int n = s.length;
  int prev = 1; // ways to decode empty prefix
  int curr = s[0] == '0' ? 0 : 1;
  for (int i = 1; i < n; i++) {
    int next = 0;
    if (s[i] != '0') next += curr;
    final two = int.parse(s.substring(i - 1, i + 1));
    if (two >= 10 && two <= 26) next += prev;
    prev = curr;
    curr = next;
  }
  return curr;
}
