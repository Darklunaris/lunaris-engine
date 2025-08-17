import 'dart:io';

bool isPrivateIp(String ip) {
  try {
    final ia = InternetAddress(ip);
    if (ia.type == InternetAddressType.IPv4) {
      final parts = ip.split('.').map(int.parse).toList();
      if (parts.length != 4) return false;
      final a = parts[0];
      final b = parts[1];
      if (a == 127) return true;
      if (a == 10) return true;
      if (a == 172 && b >= 16 && b <= 31) return true;
      if (a == 192 && b == 168) return true;
      return false;
    } else {
      final addr = ia.rawAddress;
      if (ia.address == '::1') return true;
      final firstByte = addr[0];
      if ((firstByte & 0xFE) == 0xFC) return true;
      if (firstByte == 0xFE) {
        final second = addr[1];
        if ((second & 0xC0) == 0x80) return true;
      }
      return false;
    }
  } catch (_) {
    return false;
  }
}
