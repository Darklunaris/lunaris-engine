/// Checks if the given [text] is a palindromes.
///
/// Ignores spaces and is case-insensitive.
///
/// Example:
/// ```dart
/// bool result = isPalindromes("A man a plan a canal Panama");
/// print(result); // true
/// ```
bool isPalindromes(String text) {
  String cleaned = text.replaceAll(RegExp(r'\s+'), '').toLowerCase();

  int start = 0;
  int end = cleaned.length - 1;

  while (start < end) {
    if (cleaned[start] != cleaned[end]) {
      return false;
    }
    start++;
    end--;
  }

  return true;
}
