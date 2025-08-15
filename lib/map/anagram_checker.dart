/// Checks if two sequences are anagrams of each other.
///
/// The function works with any list of comparable elements [T].
///
/// It ignores case and spaces if [T] is String; otherwise, it compares directly.
///
/// Example:
/// ```dart
/// bool result = isAnagram<String>("Listen", "Silent");
/// print(result); // true
/// ```
bool isAnagram<T>(List<T> seq1, List<T> seq2) {
  // If sequences differ in length, not anagrams
  if (seq1.length != seq2.length) return false;

  List<T> sorted1 = List.from(seq1);
  List<T> sorted2 = List.from(seq2);

  // If elements are String, normalize by trimming spaces and lowercasing
  if (T == String) {
    sorted1 =
        sorted1
            .cast<String>()
            .map((e) => e.replaceAll(' ', '').toLowerCase() as T)
            .toList();
    sorted2 =
        sorted2
            .cast<String>()
            .map((e) => e.replaceAll(' ', '').toLowerCase() as T)
            .toList();
  }

  sorted1.sort();
  sorted2.sort();

  return listEquals<T>(sorted1, sorted2);
}

/// Helper function to check if two lists are equal element-wise.
bool listEquals<T>(List<T> list1, List<T> list2) {
  if (list1.length != list2.length) return false;

  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}
