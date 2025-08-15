import 'package:test/test.dart';
import 'package:lunaris_engine/String/z_algorithm.dart';

void main() {
  test('zAlgorithm basic', () {
    expect(
      zAlgorithm('aabcaabxaaaz'),
      equals([
        0,
        1,
        0,
        0,
        3,
        1,
        0,
        0,
        2,
        2,
        1,
        0,
      ]), // Fixed: correct Z-array values
    );
  });
}
