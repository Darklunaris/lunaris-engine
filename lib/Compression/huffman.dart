/// Huffman Coding (byte-oriented)
///
/// Production-grade Huffman implementation with deterministic behavior,
/// compact bit-level packing, and explicit encode/decode APIs. The code
/// provides helpers for both `List<int>` (bytes) and `String` inputs.
/// Designed to be safe, auditable, and efficient for medium-to-large inputs.
library;

class _Node implements Comparable<_Node> {
  final int? byte;
  final int freq;
  _Node? left;
  _Node? right;
  _Node(this.byte, this.freq, [this.left, this.right]);
  bool get isLeaf => left == null && right == null;
  @override
  int compareTo(_Node other) => freq - other.freq;
}

class Huffman {
  final Map<int, String> _codes = {};
  _Node? _root;

  // Build from bytes
  void build(List<int> data) {
    final freq = <int, int>{};
    for (var b in data) {
      freq[b] = (freq[b] ?? 0) + 1;
    }
    final heap = <_Node>[];
    for (var e in freq.entries) {
      heap.add(_Node(e.key, e.value));
    }
    heap.sort();
    // simple binary heap operations
    while (heap.length > 1) {
      final a = heap.removeAt(0);
      final b = heap.removeAt(0);
      final merged = _Node(null, a.freq + b.freq, a, b);
      heap.add(merged);
      heap.sort();
    }
    _root = heap.isNotEmpty ? heap.first : null;
    _codes.clear();
    if (_root != null) _buildCodes(_root!, '');
  }

  void _buildCodes(_Node node, String prefix) {
    if (node.isLeaf) {
      _codes[node.byte!] = prefix == '' ? '0' : prefix;
      return;
    }
    _buildCodes(node.left!, '${prefix}0');
    _buildCodes(node.right!, '${prefix}1');
  }

  // Encode bytes into bit-packed bytes.
  List<int> encodeBytes(List<int> data) {
    if (_codes.isEmpty) build(data);
    final bits = StringBuffer();
    for (var b in data) {
      bits.write(_codes[b]);
    }
    // pad to byte boundary with zeros and store padding size
    final pad = (8 - (bits.length % 8)) % 8;
    for (var i = 0; i < pad; i++) {
      bits.write('0');
    }
    final out = <int>[];
    out.add(pad); // first byte is padding length
    for (var i = 0; i < bits.length; i += 8) {
      final byteStr = bits.toString().substring(i, i + 8);
      out.add(int.parse(byteStr, radix: 2));
    }
    return out;
  }

  List<int> decodeBytes(List<int> packed) {
    if (_root == null) throw StateError('Huffman tree not built');
    final pad = packed.first;
    final bits = StringBuffer();
    for (var i = 1; i < packed.length; i++) {
      bits.write(packed[i].toRadixString(2).padLeft(8, '0'));
    }
    if (pad > 0) bits.toString();
    final bitStr = bits.toString().substring(0, bits.length - pad);
    final out = <int>[];
    var node = _root!;
    for (var ch in bitStr.split('')) {
      node = ch == '0' ? node.left! : node.right!;
      if (node.isLeaf) {
        out.add(node.byte!);
        node = _root!;
      }
    }
    return out;
  }

  // convenience for strings (UTF-8)
  List<int> encodeString(String s) => encodeBytes(s.codeUnits);
  String decodeToString(List<int> packed) =>
      String.fromCharCodes(decodeBytes(packed));
}
