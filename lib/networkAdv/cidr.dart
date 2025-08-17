import 'dart:io';
import 'dart:typed_data';

Iterable<String> expandCidrLazy(String cidr) sync* {
  final parts = cidr.split('/');
  if (parts.length != 2) return;
  final base = parts[0];
  final prefix = int.tryParse(parts[1]) ?? 128;

  if (base.contains('.') && prefix <= 32) {
    final bytes = base.split('.').map(int.parse).toList();
    if (bytes.length != 4) return;
    final start =
        (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];
    final mask =
        prefix == 32 ? 0xFFFFFFFF : (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    final network = start & mask;
    final broadcast = network | (~mask & 0xFFFFFFFF);
    if (prefix >= 31) {
      for (var addr = network; addr <= broadcast; addr++) {
        final b1 = (addr >> 24) & 0xFF;
        final b2 = (addr >> 16) & 0xFF;
        final b3 = (addr >> 8) & 0xFF;
        final b4 = addr & 0xFF;
        yield '$b1.$b2.$b3.$b4';
      }
      return;
    }

    for (var addr = network + 1; addr < broadcast; addr++) {
      final b1 = (addr >> 24) & 0xFF;
      final b2 = (addr >> 16) & 0xFF;
      final b3 = (addr >> 8) & 0xFF;
      final b4 = addr & 0xFF;
      yield '$b1.$b2.$b3.$b4';
    }
    return;
  }

  try {
    final ia = InternetAddress(base);
    if (ia.type == InternetAddressType.IPv6) {
      final bytes = ia.rawAddress;
      BigInt start = BigInt.zero;
      for (final b in bytes) {
        start = (start << 8) | BigInt.from(b & 0xFF);
      }
      final totalBits = 128;
      final hostBits = totalBits - prefix;
      final count =
          hostBits >= 64 ? (BigInt.one << 64) : (BigInt.one << hostBits);
      final network = (start >> hostBits) << hostBits;
      final includeEndpoints = hostBits <= 1;
      final startOffset = includeEndpoints ? BigInt.zero : BigInt.one;
      final endOffset =
          includeEndpoints ? (count - BigInt.one) : (count - BigInt.one);
      for (
        BigInt offset = startOffset;
        offset <= endOffset;
        offset += BigInt.one
      ) {
        final addr = network + offset;
        var b = List<int>.filled(16, 0);
        var v = addr;
        for (var i = 15; i >= 0; i--) {
          b[i] = (v & BigInt.from(0xFF)).toInt();
          v = v >> 8;
        }
        yield InternetAddress.fromRawAddress(Uint8List.fromList(b)).address;
      }
    }
  } catch (_) {
    return;
  }
}

List<String> expandCidr(String cidr) => expandCidrLazy(cidr).toList();
