import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/longest_increasing_subsequence.dart';

void main() {
  group('Longest Increasing Subsequence', () {
    test('Standard case', () {
      expect(
        longestIncreasingSubsequence([10, 9, 2, 5, 3, 7, 101, 18]),
        equals(4),
      );
    });
    test('All increasing', () {
      expect(longestIncreasingSubsequence([1, 2, 3, 4, 5]), equals(5));
    });
    test('All decreasing', () {
      expect(longestIncreasingSubsequence([5, 4, 3, 2, 1]), equals(1));
    });
    test('Empty list', () {
      expect(longestIncreasingSubsequence(<Comparable>[]), equals(0));
    });
    test('Single element', () {
      expect(longestIncreasingSubsequence([42]), equals(1));
    });
  });
}
