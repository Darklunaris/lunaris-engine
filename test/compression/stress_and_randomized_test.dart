import 'dart:math';

import 'package:test/test.dart';
import 'package:lunaris_engine/Compression/lzw.dart';
import 'package:lunaris_engine/Compression/bwt.dart';
import 'package:lunaris_engine/Compression/huffman.dart';
import 'package:lunaris_engine/Compression/rle.dart';
import 'package:lunaris_engine/Compression/arithmetic.dart';

void main() {
  final rnd = Random(42);

  test('Randomized roundtrips across compressors', () {
    final sizes = [8, 64, 1024, 8192];
    for (var size in sizes) {
      final data = List<int>.generate(size, (_) => rnd.nextInt(256));

      // RLE
      final rle = RLE();
      final rleEnc = rle.encode(data);
      final rleDec = rle.decode(rleEnc);
      expect(
        rleDec,
        equals(data),
        reason: 'RLE roundtrip failed for size $size',
      );

      // Huffman (build then roundtrip)
      final h = Huffman();
      h.build(data);
      final hEnc = h.encodeBytes(data);
      final hDec = h.decodeBytes(hEnc);
      expect(
        hDec,
        equals(data),
        reason: 'Huffman roundtrip failed for size $size',
      );

      // LZW
      final l = LZW();
      final lEnc = l.encode(data);
      final lDec = l.decode(lEnc);
      expect(lDec, equals(data), reason: 'LZW roundtrip failed for size $size');

      // BWT (transform + inverse)
      final t = bwtTransform(data);
      final inv = bwtInverse(t);
      expect(inv, equals(data), reason: 'BWT roundtrip failed for size $size');

      // Arithmetic coder: build model from data, encode, then decode
      final freq = <int, int>{};
      for (var b in data) {
        freq[b] = (freq[b] ?? 0) + 1;
      }
      final alphabet = freq.keys.toList()..sort();
      final freqs = alphabet.map((a) => freq[a]!).toList();
      final ac = Arithmetic();
      final aEnc = ac.encode(data);
      final aDec = ac.decode(aEnc, alphabet, freqs, data.length);
      expect(
        aDec,
        equals(data),
        reason: 'Arithmetic roundtrip failed for size $size',
      );
    }
  });

  test(
    'Stress/perf: repeated encode/decode (medium size)',
    () {
      final size = 50 * 1024; // ~50 KB
      final data = List<int>.generate(size, (_) => rnd.nextInt(256));

      // warm-up and timed runs
      final runs = 3;

      final rle = RLE();
      final h = Huffman();
      final l = LZW();

      // RLE timing
      var sw = Stopwatch()..start();
      for (var i = 0; i < runs; i++) {
        final e = rle.encode(data);
        final d = rle.decode(e);
        expect(d, equals(data));
      }
      sw.stop();
      print('RLE: $runs runs of $size bytes -> ${sw.elapsedMilliseconds} ms');

      // Huffman timing (rebuild each run to simulate realistic usage)
      sw.reset();
      sw.start();
      for (var i = 0; i < runs; i++) {
        h.build(data);
        final e = h.encodeBytes(data);
        final d = h.decodeBytes(e);
        expect(d, equals(data));
      }
      sw.stop();
      print(
        'Huffman: $runs runs of $size bytes -> ${sw.elapsedMilliseconds} ms',
      );

      // LZW timing
      sw.reset();
      sw.start();
      for (var i = 0; i < runs; i++) {
        final e = l.encode(data);
        final d = l.decode(e);
        expect(d, equals(data));
      }
      sw.stop();
      print('LZW: $runs runs of $size bytes -> ${sw.elapsedMilliseconds} ms');
    },
    timeout: Timeout.factor(3),
  );
}
