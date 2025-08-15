/// Reverses the given input string.
///
/// Uses a two-pointer approach swapping characters from both ends.
///
/// Example:
/// ```dart
/// String reversed = reverseString("dart");
/// print(reversed); // Outputs: "trad"
/// ```
String reverseString(String input) {
  List<String> chars = input.split('');
  int start = 0;
  int end = chars.length - 1;

  while (start < end) {
    String temp = chars[start];
    chars[start] = chars[end];
    chars[end] = temp;

    start++;
    end--;
  }

  return chars.join('');
}
