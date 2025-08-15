/// Removes consecutive duplicate characters from a string [s].
///
/// Returns a new string with consecutive duplicates removed, preserving the first occurrence of each character.
///
/// Time Complexity: O(n), where n is the length of the string.
/// Space Complexity: O(n)
///
/// Example:
/// ```dart
/// print(removeConsecutiveDuplicates("aaabbcdddaa")); // Outputs: "abcda"
/// ```
String removeConsecutiveDuplicates(String s) {
  if (s.isEmpty) return s;
  final buffer = StringBuffer();
  buffer.write(s[0]);
  for (int i = 1; i < s.length; i++) {
    if (s[i] != s[i - 1]) buffer.write(s[i]);
  }
  return buffer.toString();
}
