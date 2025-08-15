import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/jump_game.dart';

void main() {
  group('Jump Game', () {
    test('Standard cases', () {
      expect(canJump([2, 3, 1, 1, 4]), isTrue);
      expect(canJump([3, 2, 1, 0, 4]), isFalse);
    });
    test('Single element', () {
      expect(canJump([0]), isTrue);
    });
    test('All zeros except first', () {
      expect(canJump([5, 0, 0, 0, 0]), isTrue);
    });
    test('Unreachable last index', () {
      expect(canJump([0, 2]), isFalse);
    });
  });
}
