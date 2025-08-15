/// Finds the length of the longest substring without repeating characters in [s].
///
/// Uses sliding window technique with a map to track last seen indices of characters.
///
/// Example:
/// ```dart
/// int length = lengthOfLongestSubstring("abcabcbb");
/// print(length); // Outputs: 3
/// ```
int lengthOfLongestSubstring(String s) {
  if (s.isEmpty) return 0;

  final Map<String, int> lastSeen = {};
  int start = 0;
  int maxLength = 0;

  for (int end = 0; end < s.length; end++) {
    String currentChar = s[end];

    if (lastSeen.containsKey(currentChar) && lastSeen[currentChar]! >= start) {
      start = lastSeen[currentChar]! + 1;
    }

    lastSeen[currentChar] = end;
    int currentLength = end - start + 1;
    if (currentLength > maxLength) {
      maxLength = currentLength;
    }
  }

  return maxLength;
}
