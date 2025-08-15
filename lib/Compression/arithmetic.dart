/// Simple arithmetic coder (order-0) for demonstration/testing
///
/// This implementation uses integer-range arithmetic coding with a
/// fixed-precision (32-bit) range. It's designed for correctness on
/// small inputs and clarity. For production you'd extend with adaptive
/// models and streaming support.
library;

// Streaming arithmetic coder (order-0) with renormalization and bit I/O.
// This implementation follows the canonical integer arithmetic coding
// approach (Witten, Neal, Cleary style) with a 32-bit coder state. It
// supports arbitrary-length inputs by emitting bits during renormalize
// steps and reloading bits during decode.

class Arithmetic {
  // Number of bits in the coding register.

  static const int _codeBits = 32;
  static final int _maxvalue = (1 << _codeBits) - 1;
  static final int _firstqtr = ((_maxvalue + 1) ~/ 4);
  static final int _half = _firstqtr * 2;
  static final int _thirdqtr = _firstqtr * 3;

  List<int> encode(List<int> data) {
    if (data.isEmpty) return [];

    // build model
    final freq = <int, int>{};
    for (var b in data) {
      freq[b] = (freq[b] ?? 0) + 1;
    }
    final alphabet = freq.keys.toList()..sort();
    final counts = alphabet.map((a) => freq[a]!).toList();
    final total = counts.fold<int>(0, (p, e) => p + e);

    // cumulative
    final cum = <int>[0];
    for (var c in counts) {
      cum.add(cum.last + c);
    }

    var low = 0;
    var high = _maxvalue;
    var bitsToFollow = 0;

    final out = <int>[];
    int bitBuffer = 0;
    int bitCount = 0;

    void outputBit(int bit) {
      bitBuffer = (bitBuffer << 1) | (bit & 1);
      bitCount++;
      if (bitCount == 8) {
        out.add(bitBuffer & 0xff);
        bitBuffer = 0;
        bitCount = 0;
      }
    }

    void outputBitPlusFollow(int bit) {
      outputBit(bit);
      for (var i = 0; i < bitsToFollow; i++) {
        outputBit(bit ^ 1);
      }
      bitsToFollow = 0;
    }

    for (var symByte in data) {
      final idx = alphabet.indexOf(symByte);
      final symLow = cum[idx];
      final symHigh = cum[idx + 1];
      final range = high - low + 1;
      high = low + (range * symHigh ~/ total) - 1;
      low = low + (range * symLow ~/ total);

      // renormalize
      while (true) {
        if (high < _half) {
          outputBitPlusFollow(0);
        } else if (low >= _half) {
          outputBitPlusFollow(1);
          low -= _half;
          high -= _half;
        } else if (low >= _firstqtr && high < _thirdqtr) {
          bitsToFollow++;
          low -= _firstqtr;
          high -= _firstqtr;
        } else {
          break;
        }
        low = low << 1;
        high = (high << 1) | 1;
      }
    }

    // finish: emit one bit and follow
    bitsToFollow++;
    if (low < _firstqtr) {
      outputBitPlusFollow(0);
    } else {
      outputBitPlusFollow(1);
    }

    // flush remaining bits (pad with zeros)
    if (bitCount > 0) {
      out.add((bitBuffer << (8 - bitCount)) & 0xff);
    }

    return out;
  }

  List<int> decode(
    List<int> encoded,
    List<int> alphabet,
    List<int> freqs,
    int outLen,
  ) {
    if (encoded.isEmpty) return [];

    final counts = List<int>.from(freqs);
    final total = counts.fold<int>(0, (p, e) => p + e);
    final cum = <int>[0];
    for (var c in counts) {
      cum.add(cum.last + c);
    }

    var low = 0;
    var high = _maxvalue;

    // bit reader
    var bytePos = 0;
    var currentByte = (bytePos < encoded.length) ? encoded[bytePos++] : 0;
    var bitsRemaining = 8;

    int getBit() {
      if (bitsRemaining == 0) {
        currentByte = (bytePos < encoded.length) ? encoded[bytePos++] : 0;
        bitsRemaining = 8;
      }
      final bit = (currentByte >> (bitsRemaining - 1)) & 1;
      bitsRemaining--;
      return bit;
    }

    // initialize value with _CODE_BITS bits
    var value = 0;
    for (var i = 0; i < _codeBits; i++) {
      value = (value << 1) | getBit();
    }

    final res = <int>[];
    for (var i = 0; i < outLen; i++) {
      final range = high - low + 1;
      final scaled = ((value - low + 1) * total - 1) ~/ range;

      // find symbol index
      var idx = 0;
      for (var j = 0; j < alphabet.length; j++) {
        if (cum[j] <= scaled && scaled < cum[j + 1]) {
          idx = j;
          break;
        }
      }
      final sym = alphabet[idx];
      res.add(sym);

      final symLow = cum[idx];
      final symHigh = cum[idx + 1];
      high = low + (range * symHigh ~/ total) - 1;
      low = low + (range * symLow ~/ total);

      // renormalize
      while (true) {
        if (high < _half) {
          // do nothing
        } else if (low >= _half) {
          value -= _half;
          low -= _half;
          high -= _half;
        } else if (low >= _firstqtr && high < _thirdqtr) {
          value -= _firstqtr;
          low -= _firstqtr;
          high -= _firstqtr;
        } else {
          break;
        }
        low = low << 1;
        high = (high << 1) | 1;
        value = (value << 1) | getBit();
      }
    }

    return res;
  }
}
