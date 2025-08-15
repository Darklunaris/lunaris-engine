/// Counts the number of vowels and consonants in a given text.
///
/// Only alphabetic characters (a-z, A-Z) are considered.
/// Vowels: a, e, i, o, u (case-insensitive).
///
/// Returns a map with keys 'vowels' and 'consonants'.
///
/// Example:
/// ```dart
/// var result = countVowelsAndConsonants("Hello World!");
/// print(result['vowels']); // 3
/// print(result['consonants']); // 7
/// ```
Map<String, int> countVowelsAndConsonants(String text) {
  final Set<String> vowels = {'a', 'e', 'i', 'o', 'u'};

  int vowelsCount = 0;
  int consonantsCount = 0;

  for (int i = 0; i < text.length; i++) {
    final String ch = text[i].toLowerCase();

    int code = ch.codeUnitAt(0);
    if (code >= 97 && code <= 122) {
      if (vowels.contains(ch)) {
        vowelsCount++;
        print('Vowel found: $ch');
      } else {
        consonantsCount++;
      }
    }
  }

  print("Total vowels: $vowelsCount, Total consonants: $consonantsCount");

  return {'vowels': vowelsCount, 'consonants': consonantsCount};
}
