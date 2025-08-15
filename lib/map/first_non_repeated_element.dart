/// Finds the first non-repeated character in a generic list of elements.
///
/// This function counts the frequency of each element in the input list
/// and returns the first element whose frequency is exactly one.
///
/// It works with any type `T` that supports equality comparison.
///
/// Returns `null` if there is no non-repeated element.
///
/// Example:
/// ```dart
/// var result = firstNonRepeatedElement<String>(['a', 'a', 'b', 'c', 'd', 'e']);
/// print(result); // Outputs: b
///
/// var nums = [1, 2, 2, 3, 3];
/// print(firstNonRepeatedElement<int>(nums)); // Outputs: 1
/// ```
T? firstNonRepeatedElement<T>(List<T> input) {
  final Map<T, int> freqMap = {};

  // Count frequency of each element
  for (var element in input) {
    freqMap[element] = (freqMap[element] ?? 0) + 1;
  }

  // Find first element with frequency == 1
  for (var element in input) {
    if (freqMap[element] == 1) {
      return element;
    }
  }

  return null;
}

/// Helper function to print the result for a list of generic elements.
void printResult<T>(List<T> input) {
  final result = firstNonRepeatedElement(input);

  if (result != null) {
    print("First non-repeated element in $input is: '$result'");
  } else {
    print("No non-repeated element found in $input");
  }
}
