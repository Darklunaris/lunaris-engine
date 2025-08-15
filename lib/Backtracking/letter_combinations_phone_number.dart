/// Generates all possible letter combinations for a phone number using backtracking.
///
/// This function returns all possible letter combinations that the input digit string [digits] could represent,
/// based on the mapping of digits to letters on a phone keypad (2-9). Each digit maps to a set of letters, and the function
/// produces all possible strings by choosing one letter per digit.
///
/// Time Complexity: O(3^n * 4^m), where n is the number of digits mapping to 3 letters and m is the number mapping to 4 letters.
///
/// Example:
/// ```dart
/// var result = letterCombinations("23");
/// print(result); // Outputs: ["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"]
/// ```
List<String> letterCombinations(String digits) {
  if (digits.isEmpty) return [];
  const Map<String, String> phone = {
    '2': 'abc',
    '3': 'def',
    '4': 'ghi',
    '5': 'jkl',
    '6': 'mno',
    '7': 'pqrs',
    '8': 'tuv',
    '9': 'wxyz',
  };
  List<String> result = [];
  void backtrack(int idx, String path) {
    if (idx == digits.length) {
      result.add(path);
      return;
    }
    for (final ch in phone[digits[idx]]!.split('')) {
      backtrack(idx + 1, path + ch);
    }
  }

  backtrack(0, '');
  return result;
}
