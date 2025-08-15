/// Finds the longest palindromic substring in a string using Manacher's Algorithm (O(n) time).
///
/// This function implements Manacher's Algorithm to find the longest palindromic substring in linear time.
/// It preprocesses the string to handle both odd and even length palindromes uniformly.
///
/// Time Complexity: O(n), where n is the length of the string.
/// Space Complexity: O(n)
///
/// Example:
/// ```dart
/// String s = "babad";
/// print(manacherLongestPalindrome(s)); // Outputs: "bab" or "aba"
/// ```
String manacherLongestPalindrome(String s) {
  if (s.isEmpty) return '';
  final t = '^#${s.split('').join('#')}#\$';
  final p = List<int>.filled(t.length, 0);
  int center = 0, right = 0, maxLen = 0, start = 0;
  for (int i = 1; i < t.length - 1; i++) {
    int mirror = 2 * center - i;
    if (right > i) p[i] = p[mirror].clamp(0, right - i);
    while (t[i + 1 + p[i]] == t[i - 1 - p[i]]) {
      p[i]++;
    }
    if (i + p[i] > right) {
      center = i;
      right = i + p[i];
    }
    if (p[i] > maxLen) {
      maxLen = p[i];
      start = (i - maxLen) ~/ 2;
    }
  }
  return s.substring(start, start + maxLen);
}
