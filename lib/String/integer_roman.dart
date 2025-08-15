/// Converts an integer to its Roman numeral representation.
///
/// This function takes an integer [num] and returns its Roman numeral as a string.
///
/// Time Complexity: O(1) (since the number of Roman numeral symbols is constant)
///
/// Example:
/// ```dart
/// print(intToRoman(1994)); // Outputs: "MCMXCIV"
/// ```
String intToRoman(int num) {
  final val = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
  final syms = [
    "M",
    "CM",
    "D",
    "CD",
    "C",
    "XC",
    "L",
    "XL",
    "X",
    "IX",
    "V",
    "IV",
    "I",
  ];
  final sb = StringBuffer();
  for (int i = 0; i < val.length && num > 0; i++) {
    while (num >= val[i]) {
      num -= val[i];
      sb.write(syms[i]);
    }
  }
  return sb.toString();
}

/// Converts a Roman numeral string to its integer representation.
///
/// This function takes a Roman numeral [s] and returns its integer value.
///
/// Time Complexity: O(n), where n is the length of the string [s].
///
/// Example:
/// ```dart
/// print(romanToInt("MCMXCIV")); // Outputs: 1994
/// ```
int romanToInt(String s) {
  final map = {'I': 1, 'V': 5, 'X': 10, 'L': 50, 'C': 100, 'D': 500, 'M': 1000};
  int result = 0, prev = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    int curr = map[s[i]]!;
    if (curr < prev) {
      result -= curr;
    } else {
      result += curr;
    }
    prev = curr;
  }
  return result;
}
