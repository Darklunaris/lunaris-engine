import 'package:lunaris_engine/String/string_compression.dart';
import 'package:test/test.dart';

void main() {
  group('String Compression Tests', () {
    test('Compression outputs correct results', () {
      expect(
        compressString("aaabbc"),
        anyOf("a3b2c1", "aaabbc"),
      ); // Accepts original if compression not shorter
      expect(compressString("abc"), "abc");
      expect(compressString("aabbccdde"), "aabbccdde");
      expect(compressString("aaaaaaaaaa"), "a10");
      expect(compressString(""), "");
    });

    test('Handles empty string correctly', () {
      expect(compressString(""), "");
    });

    test('Returns original when compressed is not smaller', () {
      expect(compressString("abcd"), "abcd");
      expect(compressString("aabb"), "aabb");
    });
  });
}
