import 'package:test/test.dart';
import 'package:lunaris_engine/String/min_window_subsequence.dart';

void main() {
  test('minWindowSubsequence basic', () {
    expect(minWindowSubsequence('abcdebdde', 'bde'), equals('bcde'));
    expect(minWindowSubsequence('abc', 'ac'), equals('abc'));
    expect(minWindowSubsequence('abc', 'd'), equals(''));
  });
}
