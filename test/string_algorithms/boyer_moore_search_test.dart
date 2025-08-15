import 'package:test/test.dart';
import 'package:lunaris_engine/String/boyer_moore_search.dart';

void main() {
  test('boyerMooreSearch basic', () {
    expect(boyerMooreSearch('hello world', 'world'), equals(6));
    expect(boyerMooreSearch('abc', 'd'), equals(-1));
    expect(boyerMooreSearch('abc', ''), equals(0));
  });
}
