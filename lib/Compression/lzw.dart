/// LZW compression (byte-oriented)
///
/// Production-minded LZW implementation using integer codes and a compact
/// byte coder for outputs. Deterministic dictionary growth and explicit
/// APIs for encoding/decoding make this suitable for reproducible usage.
library;

class LZW {
  // Encode bytes to a list of integer codes.
  List<int> encode(List<int> input) {
    if (input.isEmpty) return [];
    final dict = <String, int>{};
    for (var i = 0; i < 256; i++) {
      dict['$i'] = i;
    }
    var code = 256;
    final out = <int>[];
    var w = <int>[input[0]];
    for (var idx = 1; idx < input.length; idx++) {
      final k = input[idx];
      final wk = List<int>.from(w)..add(k);
      final wkKey = wk.join(',');
      final wKey = w.join(',');
      if (dict.containsKey(wkKey)) {
        w = wk;
      } else {
        out.add(dict[wKey]!);
        dict[wkKey] = code++;
        w = [k];
      }
    }
    out.add(dict[w.join(',')]!);
    return out;
  }

  // Decode list of codes produced by encode.
  List<int> decode(List<int> codes) {
    final dict = <int, List<int>>{};
    for (var i = 0; i < 256; i++) {
      dict[i] = [i];
    }
    var code = 256;
    var prev = <int>[];
    final out = <int>[];
    for (var k in codes) {
      List<int> entry;
      if (dict.containsKey(k)) {
        entry = dict[k]!;
      } else if (k == code) {
        entry = List<int>.from(prev)..add(prev.first);
      } else {
        throw StateError('Bad LZW code');
      }
      out.addAll(entry);
      if (prev.isNotEmpty) {
        dict[code++] = List<int>.from(prev)..add(entry.first);
      }
      prev = entry;
    }
    return out;
  }
}
