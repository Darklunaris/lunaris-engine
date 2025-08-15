/// Checks whether two strings [str1] and [str2] are anagrams of each other.
///
/// This function ignores spaces and is case-insensitive.
///
/// Example:
/// ```dart
/// bool result = areAnagrams("listen", "silent");
/// print(result); // true
/// ```
bool areAnagrams(String str1, String str2) {
  String clean1 = str1.replaceAll(RegExp(r'\s+'), '').toLowerCase();
  String clean2 = str2.replaceAll(RegExp(r'\s+'), '').toLowerCase();

  if (clean1.length != clean2.length) return false;

  Map<String, int> countMap1 = {};
  Map<String, int> countMap2 = {};

  for (var ch in clean1.split('')) {
    countMap1[ch] = (countMap1[ch] ?? 0) + 1;
  }

  for (var ch in clean2.split('')) {
    countMap2[ch] = (countMap2[ch] ?? 0) + 1;
  }

  if (countMap1.length != countMap2.length) return false;

  for (var entry in countMap1.entries) {
    if (countMap2[entry.key] != entry.value) {
      return false;
    }
  }

  return true;
}
