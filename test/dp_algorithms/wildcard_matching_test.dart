import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('isWildcardMatch', () {
    test('example', () {
      expect(isWildcardMatch('aa', 'a*'), isTrue);
    });
  });
}
