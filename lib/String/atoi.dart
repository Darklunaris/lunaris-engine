/// String to Integer (Atoi): Converts a string to an integer, handling optional +/- and whitespace.
/// Converts a string [s] to an integer, handling optional +/- and whitespace (Atoi).
///
/// Ignores leading whitespace, parses an optional sign, and reads digits until a non-digit is found.
///
/// Returns the integer value represented by [s].
///
/// Example:
/// ```dart
/// print(atoi("   -42")); // -42
/// print(atoi("4193 with words")); // 4193
/// ```
int atoi(String s) {
  int i = 0, n = s.length, sign = 1, result = 0;
  while (i < n && s[i] == ' ') {
    i++;
  }
  if (i < n && (s[i] == '-' || s[i] == '+')) sign = s[i++] == '-' ? -1 : 1;
  while (i < n && s[i].codeUnitAt(0) >= 48 && s[i].codeUnitAt(0) <= 57) {
    result = result * 10 + (s[i++].codeUnitAt(0) - 48);
  }
  return sign * result;
}
