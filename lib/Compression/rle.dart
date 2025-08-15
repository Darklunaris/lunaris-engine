/// Run-Length Encoding (RLE)
///
/// Simple, high-performance RLE for byte sequences with robust boundaries.
/// The implementation packs runs as (value, count) pairs. Designed for
/// streaming and large datasets; graceful behavior on long runs.
library;

class RLE {
  List<int> encode(List<int> src) {
    if (src.isEmpty) return [];
    final out = <int>[];
    var cur = src[0];
    var cnt = 1;
    for (var i = 1; i < src.length; i++) {
      if (src[i] == cur && cnt < 255) {
        cnt++;
      } else {
        out.add(cur);
        out.add(cnt);
        cur = src[i];
        cnt = 1;
      }
    }
    out.add(cur);
    out.add(cnt);
    return out;
  }

  List<int> decode(List<int> packed) {
    final out = <int>[];
    for (var i = 0; i + 1 < packed.length; i += 2) {
      final v = packed[i];
      final c = packed[i + 1];
      for (var j = 0; j < c; j++) {
        out.add(v);
      }
    }
    return out;
  }
}
