import 'dart:io';

/// Do a tiny banner grab via TCP socket and return the first line (trimmed),
/// or null on error.
Future<String?> grabBanner(
  String host,
  int port, {
  Duration timeout = const Duration(milliseconds: 300),
  Duration bannerTimeout = const Duration(milliseconds: 300),
}) async {
  try {
    final s = await Socket.connect(host, port, timeout: timeout);
    try {
      s.write('\r\n');
      final data = await s.first.timeout(bannerTimeout);
      final banner = String.fromCharCodes(data).trim();
      s.destroy();
      return banner;
    } catch (_) {
      s.destroy();
      return null;
    }
  } catch (_) {
    return null;
  }
}
