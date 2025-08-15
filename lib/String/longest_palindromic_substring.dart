/// Expands around the given center indices [left] and [right] in string [s]
/// to find the longest palindrome substring.
///
/// Returns the palindrome substring found.
///
/// This helper function is used by [longestPalindrome].
String _expandAroundCenter(String s, int left, int right) {
  while (left >= 0 && right < s.length && s[left] == s[right]) {
    left--;
    right++;
  }
  return s.substring(left + 1, right);
}

/// Returns the longest palindromic substring in the given string [s].
///
/// Uses center expansion technique checking both odd and even length palindromes.
///
/// Example:
/// ```dart
/// String longest = longestPalindrome("babad");
/// print(longest); // Outputs "bab" or "aba"
/// ```
String longestPalindrome(String s) {
  if (s.isEmpty) return "";

  String longest = "";

  for (int i = 0; i < s.length; i++) {
    String oddPalindrome = _expandAroundCenter(s, i, i);
    String evenPalindrome = _expandAroundCenter(s, i, i + 1);

    String longerPalindrome =
        oddPalindrome.length > evenPalindrome.length
            ? oddPalindrome
            : evenPalindrome;

    if (longerPalindrome.length > longest.length) {
      longest = longerPalindrome;
    }
  }

  return longest;
}
