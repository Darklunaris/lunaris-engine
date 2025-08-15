import 'package:test/test.dart';
import 'package:lunaris_engine/String/rolling_hash.dart';

void main() {
  test('rollingHashSearch basic', () {
    expect(rollingHashSearch('abracadabra', 'abra'), equals([0, 7]));
    expect(rollingHashSearch('abc', 'd'), isEmpty);
  });
}
