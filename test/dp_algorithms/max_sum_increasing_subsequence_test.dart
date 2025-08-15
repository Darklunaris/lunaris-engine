import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('maxSumIncreasingSubsequence', () {
    test('example', () {
      expect(
        maxSumIncreasingSubsequence([1, 101, 2, 3, 100, 4, 5]),
        equals(106),
      );
    });
  });
}
