/// Generates all unique permutations of a given string.
///
/// This function returns a list of all unique permutations of the input string [s].
/// It uses backtracking to generate permutations and handles duplicate characters.
///
/// Time Complexity: O(n!), where n is the length of the string.
/// Space Complexity: O(n!)
///
/// Example:
/// ```dart
/// List<String> perms = stringPermutations("abc");
/// print(perms); // Outputs: ["abc", "acb", "bac", "bca", "cab", "cba"]
/// ```
List<String> stringPermutations(String s) {
  final result = <String>[];
  void permute(List<String> chars, int l) {
    if (l == chars.length - 1) {
      result.add(chars.join());
      return;
    }
    final seen = <String>{};
    for (int i = l; i < chars.length; i++) {
      if (seen.add(chars[i])) {
        chars.swap(l, i);
        permute(chars, l + 1);
        chars.swap(l, i);
      }
    }
  }

  permute(s.split(''), 0);
  return result;
}

extension _SwapList<T> on List<T> {
  void swap(int i, int j) {
    final tmp = this[i];
    this[i] = this[j];
    this[j] = tmp;
  }
}
