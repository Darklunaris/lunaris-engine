import 'package:test/test.dart';
import 'package:lunaris_engine/Set/list_to_set_preserve_order.dart';

void main() {
  test('listToSetPreserveOrder basic', () {
    expect(listToSetPreserveOrder([3, 1, 2, 3, 2]), equals([3, 1, 2]));
    expect(listToSetPreserveOrder(<int>[]), isEmpty);
    expect(listToSetPreserveOrder([1, 1, 1]), equals([1]));
  });
}
