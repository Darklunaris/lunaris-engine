import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('minCutsPalindromePartition', () {
    test('aab', () {
      expect(minCutsPalindromePartition('aab'), equals(1));
    });
  });
}
