import 'dart:convert';
import 'dart:io';

Future<List<String>> traceroute(String host, {int maxHops = 30}) async {
  try {
    final proc = await Process.start('traceroute', ['-m', '$maxHops', host]);
    final out = <String>[];
    await for (final line in proc.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      out.add(line);
    }
    await proc.exitCode;
    return out;
  } catch (_) {
    return [];
  }
}

Future<Map<String, dynamic>?> geoIpLookup(
  String ip, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  try {
    final uri = Uri.parse(
      'http://ip-api.com/json/$ip?fields=status,country,regionName,city,isp,org,as,query',
    );
    final client = HttpClient();
    client.connectionTimeout = timeout;
    final req = await client.getUrl(uri).timeout(timeout);
    final resp = await req.close().timeout(timeout);
    final body = await resp.transform(utf8.decoder).join();
    client.close();
    final map = jsonDecode(body) as Map<String, dynamic>;
    if (map['status'] == 'success') {
      return map;
    }
    return null;
  } catch (_) {
    return null;
  }
}
