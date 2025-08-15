import 'package:test/test.dart';
import 'package:lunaris_engine/map/find_subarrays_with_sum.dart';

void main() {
  test('findSubarraysWithSum basic', () {
    final nums = [10, 2, -2, -20, 10];
    final result = findSubarraysWithSum(nums, -10);
    expect(
      result,
      containsAll([
        [0, 3],
        [1, 4],
      ]),
    );
  });
}
