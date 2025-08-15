import 'package:test/test.dart';
import 'package:lunaris_engine/String/string_permutations.dart';

void main() {
  test('stringPermutations basic', () {
    final perms = stringPermutations('abc');
    expect(
      perms.toSet(),
      containsAll({'abc', 'acb', 'bac', 'bca', 'cab', 'cba'}),
    );
    expect(stringPermutations('a'), equals(['a']));
  });
}
