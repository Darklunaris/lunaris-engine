import 'package:test/test.dart';
import 'package:lunaris_engine/Compression/arithmetic.dart';

void main() {
  test('Arithmetic basic encode (smoke)', () {
    final a = Arithmetic();
    final src = 'ABRACADABRA'.codeUnits;
    final enc = a.encode(src);
    expect(enc.isNotEmpty, isTrue);
  });
}
