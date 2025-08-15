import 'package:lunaris_engine/String/edit_distance.dart';
import 'package:test/test.dart';

void main() {
  group('Edit Distance Tests', () {
    test('Basic examples', () {
      expect(editDistance("horse", "ros"), 3);
      expect(editDistance("intention", "execution"), 5);
      expect(editDistance("", ""), 0);
      expect(editDistance("abc", ""), 3);
      expect(editDistance("", "abc"), 3);
      expect(editDistance("kitten", "sitting"), 3);
    });
  });
}
