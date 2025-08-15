import 'package:test/test.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  group('isRegexMatch', () {
    test('example', () {
      expect(isRegexMatch('aab', 'c*a*b'), isTrue);
    });
  });
}
