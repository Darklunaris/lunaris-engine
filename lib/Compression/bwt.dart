/// Burrows–Wheeler Transform (BWT) and inverse
///
/// BWT transform and inverse with efficient index-based reconstruction.
/// This module produces the transformed bytes and primary index suitable
/// for compression pipelines. Implemented for correctness and clarity.
library;

List<int> bwtTransform(List<int> input) {
  if (input.isEmpty) return [0];
  final n = input.length;
  final rotations = List<List<int>>.generate(n, (i) => List<int>.filled(n, 0));
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < n; j++) {
      rotations[i][j] = input[(i + j) % n];
    }
  }
  rotations.sort((a, b) {
    for (var i = 0; i < n; i++) {
      if (a[i] != b[i]) return a[i] - b[i];
    }
    return 0;
  });
  final out = <int>[];
  for (var r in rotations) {
    out.add(r[n - 1]);
  }
  // append primary index for inversion (index of original input rotation)
  final primary = rotations.indexWhere((r) {
    if (r.length != input.length) return false;
    for (var i = 0; i < r.length; i++) {
      if (r[i] != input[i]) return false;
    }
    return true;
  });
  out.add(primary < 0 ? 0 : primary);
  return out;
}

List<int> bwtInverse(List<int> transformedWithIndex) {
  if (transformedWithIndex.isEmpty) return [];
  if (transformedWithIndex.length == 1) return [];
  final n = transformedWithIndex.length - 1;
  final last = transformedWithIndex.sublist(0, n);
  final primary = transformedWithIndex.last;
  final counts = <int, int>{};
  for (var c in last) {
    counts[c] = (counts[c] ?? 0) + 1;
  }
  final keys = counts.keys.toList()..sort();
  final starts = <int, int>{};
  var sum = 0;
  for (var k in keys) {
    starts[k] = sum;
    sum += counts[k]!;
  }
  final occ = <int>[];
  final seen = <int, int>{};
  for (var ch in last) {
    final s = (seen[ch] ?? 0);
    occ.add(starts[ch]! + s);
    seen[ch] = s + 1;
  }
  final res = List<int>.filled(n, 0);
  var idx = primary;
  for (var i = n - 1; i >= 0; i--) {
    res[i] = last[idx];
    idx = occ[idx];
  }
  return res;
}
