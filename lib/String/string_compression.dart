/// Compresses the input string by replacing consecutive repeated characters
/// with the character followed by the count of repetitions.
///
/// If the compressed string is not shorter than the original, returns the original.
///
/// This implementation runs in O(n) time and O(n) space,
/// where n is the length of the input string.
///
/// Example:
/// ```dart
/// String compressed = compressString("aaabbc");
/// print(compressed); // Outputs: "a3b2c1"
/// ```
String compressString(String input) {
  if (input.isEmpty) return input;

  final buffer = StringBuffer();
  int count = 1;

  // Iterate from second character to the end
  for (int i = 1; i < input.length; i++) {
    if (input[i] == input[i - 1]) {
      count++;
    } else {
      buffer
        ..write(input[i - 1])
        ..write(count);
      count = 1;
    }
  }

  // Append the last character and its count
  buffer
    ..write(input[input.length - 1])
    ..write(count);

  final compressed = buffer.toString();

  // Return original if compression doesn't reduce size
  return compressed.length < input.length ? compressed : input;
}
