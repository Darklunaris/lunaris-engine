import 'package:test/test.dart';
import 'package:lunaris_engine/map/group_anagrams.dart';

void main() {
  test('groupAnagrams basic', () {
    final words = ['eat', 'tea', 'tan', 'ate', 'nat', 'bat'];
    final result = groupAnagrams(words);
    expect(
      result.any((g) => g.toSet().containsAll(['eat', 'tea', 'ate'])),
      isTrue,
    );
    expect(result.any((g) => g.toSet().containsAll(['tan', 'nat'])), isTrue);
    expect(result.any((g) => g.toSet().containsAll(['bat'])), isTrue);
  });
}
