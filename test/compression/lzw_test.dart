import 'package:test/test.dart';
import 'package:lunaris_engine/Compression/lzw.dart';

void main() {
  test('LZW roundtrip', () {
    final l = LZW();
    final src = 'TOBEORNOTTOBEORTOBEORNOT'.codeUnits;
    final codes = l.encode(src);
    final dec = l.decode(codes);
    expect(String.fromCharCodes(dec), equals('TOBEORNOTTOBEORTOBEORNOT'));
  });
}
