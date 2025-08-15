/// Rabin-Karp algorithm for substring search.
///
/// Returns the starting index of the first occurrence of [pattern] in [text].
/// Returns -1 if [pattern] is not found.
///
/// The algorithm uses a rolling hash technique to achieve average O(n + m) time,
/// where n is length of text and m is length of pattern.
///
/// Parameters:
/// - [text]: The text string to search within.
/// - [pattern]: The pattern string to search for.
///
/// Example:
/// ```dart
/// int index = rabinKarpSearch("hello world", "world");
/// print(index); // 6
/// ```
int rabinKarpSearch(String text, String pattern) {
  int n = text.length;
  int m = pattern.length;

  if (m == 0) return 0; // empty pattern matches at index 0
  if (m > n) return -1; // pattern longer than text => no match

  const int base = 256; // number of possible characters (ASCII)
  const int mod = 101; // a prime number to reduce collisions

  // Compute base^(m-1) % mod for use in rolling hash
  int highOrder = 1;
  for (int i = 0; i < m - 1; i++) {
    highOrder = (highOrder * base) % mod;
  }

  int patternHash = 0;
  int windowHash = 0;

  // Initial hash computation for pattern and first window of text
  for (int i = 0; i < m; i++) {
    patternHash = (base * patternHash + pattern.codeUnitAt(i)) % mod;
    windowHash = (base * windowHash + text.codeUnitAt(i)) % mod;
  }

  // Slide over text
  for (int i = 0; i <= n - m; i++) {
    // Check hash equality and then verify characters to avoid false positives
    if (patternHash == windowHash) {
      bool match = true;
      for (int j = 0; j < m; j++) {
        if (text[i + j] != pattern[j]) {
          match = false;
          break;
        }
      }
      if (match) {
        return i; // Match found at index i
      }
    }

    // Compute hash for next window: Remove leading char, add trailing char
    if (i < n - m) {
      windowHash =
          (base * (windowHash - text.codeUnitAt(i) * highOrder) +
              text.codeUnitAt(i + m)) %
          mod;

      // Ensure positive hash value
      if (windowHash < 0) {
        windowHash += mod;
      }
    }
  }

  return -1; // No match found
}
