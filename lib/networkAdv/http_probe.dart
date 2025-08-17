import 'dart:io';

/// Performs a lightweight HTTP HEAD probe returning headers map and resolved
/// first IP (or null). Does not throw — returns nulls on failure.
Future<Map<String, dynamic>> httpHeadProbe(
  String host, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final out = <String, dynamic>{'headers': null, 'ip': null};
  try {
    final uri = Uri.parse('https://$host/');
    final reqClient = HttpClient();
    reqClient.connectionTimeout = timeout;
    final req = await reqClient.openUrl('HEAD', uri).timeout(timeout);
    final resp = await req.close().timeout(timeout);
    final headersMap = <String, String>{};
    resp.headers.forEach((k, v) => headersMap[k] = v.join(', '));
    out['headers'] = headersMap;
    try {
      final addrList = await InternetAddress.lookup(host);
      if (addrList.isNotEmpty) out['ip'] = addrList.first.address;
    } catch (_) {}
    reqClient.close(force: true);
  } catch (_) {}
  return out;
}
