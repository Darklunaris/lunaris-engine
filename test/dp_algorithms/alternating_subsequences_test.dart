import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/alternating_subsequences.dart';

void main() {
  group('Alternating Subsequences', () {
    test('Standard cases', () {
      expect(longestAlternatingSubsequence([1, 5, 4]), equals(3));
      expect(longestAlternatingSubsequence([1, 7, 4, 9, 2, 5]), equals(6));
      expect(longestAlternatingSubsequence([1, 2, 3, 4, 5]), equals(2));
      expect(longestAlternatingSubsequence([5, 4, 3, 2, 1]), equals(2));
    });
    test('Empty list', () {
      expect(longestAlternatingSubsequence([]), equals(0));
    });
    test('Single element', () {
      expect(longestAlternatingSubsequence([42]), equals(1));
    });
  });
}
