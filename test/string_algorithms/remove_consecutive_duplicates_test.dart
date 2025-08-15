import 'package:test/test.dart';
import 'package:lunaris_engine/String/remove_consecutive_duplicates.dart';

void main() {
  test('removeConsecutiveDuplicates basic', () {
    expect(removeConsecutiveDuplicates('aabbcc'), equals('abc'));
    expect(removeConsecutiveDuplicates('a'), equals('a'));
    expect(removeConsecutiveDuplicates(''), equals(''));
  });
}
