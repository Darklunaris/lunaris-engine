void main() {
  final expected = [
    {},
    {1},
    {2},
    {1, 2},
  ];
  for (var i = 0; i < expected.length; i++) {
    print(
      'expected[$i] type: \\${expected[i].runtimeType} value: \\${expected[i]}',
    );
  }
}
