import 'package:test/test.dart';
import 'package:lunaris_engine/dp_algorithms/house_robber.dart';

void main() {
  group('House Robber', () {
    test('Standard cases', () {
      expect(houseRobber([1, 2, 3, 1]), equals(4));
      expect(houseRobber([2, 7, 9, 3, 1]), equals(12));
    });
    test('Empty list', () {
      expect(houseRobber([]), equals(0));
    });
    test('Single house', () {
      expect(houseRobber([5]), equals(5));
    });
    test('Two houses', () {
      expect(houseRobber([2, 3]), equals(3));
    });
  });
}
