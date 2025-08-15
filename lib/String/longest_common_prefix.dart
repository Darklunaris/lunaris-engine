/// Finds the longest common prefix string amongst an array of strings.
///
/// Returns an empty string if the input list is empty or if there is no common prefix.
///
/// Example:
/// ```dart
/// List<String> strs = ["flower", "flow", "flight"];
/// print(longestCommonPrefix(strs)); // "fl"
/// ```
String longestCommonPrefix(List<String> strs) {
  if (strs.isEmpty) return "";

  String prefix = strs[0];

  for (int i = 1; i < strs.length; i++) {
    prefix = _commonPrefix(prefix, strs[i]);
    if (prefix.isEmpty) break;
  }

  return prefix;
}

/// Helper function to find common prefix between two strings.
String _commonPrefix(String str1, String str2) {
  int minLength = str1.length < str2.length ? str1.length : str2.length;
  int i = 0;

  while (i < minLength && str1[i] == str2[i]) {
    i++;
  }

  return str1.substring(0, i);
}
