import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('longestBitonicSubsequence', () {
    test('example', () {
      final arr = [1, 11, 2, 10, 4, 5, 2, 1];
      expect(longestBitonicSubsequence(arr), equals(6));
    });

    test('strictly increasing', () {
      expect(longestBitonicSubsequence([1, 2, 3, 4, 5]), equals(5));
    });

    test('empty', () {
      expect(longestBitonicSubsequence([]), equals(0));
    });
  });
}
