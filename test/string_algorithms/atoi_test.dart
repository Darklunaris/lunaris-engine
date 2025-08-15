import 'package:test/test.dart';
import 'package:lunaris_engine/String/atoi.dart';

void main() {
  test('atoi basic', () {
    expect(atoi('42'), equals(42));
    expect(atoi('   -42'), equals(-42));
    expect(atoi('4193 with words'), equals(4193));
    expect(atoi('words and 987'), equals(0));
    expect(atoi('-91283472332'), equals(-91283472332));
  });
}
