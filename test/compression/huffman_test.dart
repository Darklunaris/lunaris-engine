import 'package:test/test.dart';
import 'package:lunaris_engine/Compression/huffman.dart';

void main() {
  test('Huffman roundtrip', () {
    final h = Huffman();
    final data = 'this is an example of a huffman tree'.codeUnits;
    final packed = h.encodeBytes(data);
    final decoded = h.decodeBytes(packed);
    expect(
      String.fromCharCodes(decoded),
      equals('this is an example of a huffman tree'),
    );
  });
}
