String identifyProtocolFromBanner(String banner) {
  final s = banner.trim();
  if (s.startsWith('SSH-')) {
    return 'SSH';
  }
  if (RegExp(r'^HTTP/\d', caseSensitive: false).hasMatch(s) ||
      s.toLowerCase().contains('server:')) {
    return 'HTTP';
  }
  if (RegExp(r'^220', caseSensitive: false).hasMatch(s) &&
      s.toUpperCase().contains('FTP')) {
    return 'FTP';
  }
  if (RegExp(r'^220', caseSensitive: false).hasMatch(s) &&
      s.toUpperCase().contains('SMTP')) {
    return 'SMTP';
  }
  if (s.startsWith('220')) {
    return 'SMTP/FTP';
  }
  if (s.startsWith('220 ')) {
    return 'Service';
  }
  if (s.toUpperCase().contains('TLS') || s.toUpperCase().contains('SSL')) {
    return 'TLS/SSL';
  }
  if (RegExp(r'GET |POST |HEAD ', caseSensitive: false).hasMatch(s)) {
    return 'HTTP-REQ';
  }
  return '';
}

String wellKnownPortService(int port) {
  switch (port) {
    case 21:
      return 'ftp';
    case 22:
      return 'ssh';
    case 23:
      return 'telnet';
    case 25:
      return 'smtp';
    case 53:
      return 'dns';
    case 80:
      return 'http';
    case 110:
      return 'pop3';
    case 143:
      return 'imap';
    case 443:
      return 'https';
    case 3306:
      return 'mysql';
    case 3389:
      return 'rdp';
    case 8080:
      return 'http-alt';
    default:
      return 'unknown';
  }
}

Map<String, dynamic> serviceSeverity(String service, int port) {
  final s = service.toLowerCase();
  if (s.contains('telnet') || port == 23) {
    return {
      'level': 'critical',
      'score': 9,
      'note': 'Cleartext remote shell (Telnet)',
    };
  }
  if (s.contains('rdp') || port == 3389) {
    return {'level': 'high', 'score': 8, 'note': 'Remote Desktop exposed'};
  }
  if (s.contains('mysql') || port == 3306 || s.contains('mariadb')) {
    return {
      'level': 'high',
      'score': 8,
      'note': 'Database port exposed without authentication checks',
    };
  }
  if (s.contains('ftp') || port == 21) {
    return {
      'level': 'high',
      'score': 7,
      'note': 'FTP may expose credentials (cleartext)',
    };
  }
  if (s.contains('ssh') || port == 22) {
    return {
      'level': 'medium',
      'score': 5,
      'note': 'SSH exposed (use key auth and strong configs)',
    };
  }
  if (s.contains('http') || port == 80 || port == 8080) {
    return {
      'level': 'medium',
      'score': 5,
      'note':
          'HTTP service; check for outdated software and missing security headers',
    };
  }
  if (s.contains('https') || port == 443) {
    return {
      'level': 'medium',
      'score': 5,
      'note': 'HTTPS exposed; check certificate and TLS config',
    };
  }
  if (s.contains('smtp') || port == 25) {
    return {
      'level': 'medium',
      'score': 5,
      'note': 'SMTP service; check for open relays',
    };
  }
  if (s.contains('dns') || port == 53) {
    return {
      'level': 'low',
      'score': 3,
      'note': 'DNS exposed; consider restricting or rate-limiting',
    };
  }
  if (s.contains('imap') || s.contains('pop3') || port == 110 || port == 143) {
    return {'level': 'low', 'score': 3, 'note': 'Legacy mail services exposed'};
  }
  return {
    'level': 'info',
    'score': 1,
    'note': 'Unclassified service  validate manually',
  };
}

Map<String, dynamic> fingerprintService({
  Map<String, String>? headers,
  String? banner,
}) {
  final result = <String, dynamic>{
    'name': null,
    'version': null,
    'confidence': 0,
  };
  try {
    final server =
        headers != null && headers.containsKey('server')
            ? headers['server']!.toLowerCase()
            : null;
    if (server != null) {
      if (server.contains('apache')) {
        result['name'] = 'Apache';
        final m = RegExp(r'apache/?(?:\s*)([\d.]+)?').firstMatch(server);
        if (m != null) result['version'] = m.group(1);
        result['confidence'] = 90;
        return result;
      }
      if (server.contains('nginx')) {
        result['name'] = 'nginx';
        final m = RegExp(r'nginx/?(?:\s*)([\d.]+)?').firstMatch(server);
        if (m != null) result['version'] = m.group(1);
        result['confidence'] = 90;
        return result;
      }
      if (server.contains('cloudflare')) {
        result['name'] = 'cloudflare';
        result['confidence'] = 80;
        return result;
      }
      if (server.contains('vercel') || server.contains('now')) {
        result['name'] = 'Vercel';
        result['confidence'] = 85;
        return result;
      }
      if (server.contains('gunicorn') || server.contains('uwsgi')) {
        result['name'] = 'python-wsgi';
        result['confidence'] = 70;
        return result;
      }
      if (server.contains('node') || server.contains('express')) {
        result['name'] = 'node.js';
        result['confidence'] = 70;
        return result;
      }
    }

    if (banner != null) {
      final b = banner.toLowerCase();
      if (b.contains('nginx')) {
        result['name'] = 'nginx';
        result['confidence'] = 60;
        return result;
      }
      if (b.contains('apache')) {
        result['name'] = 'Apache';
        result['confidence'] = 60;
        return result;
      }
      if (b.contains('http') && b.contains('node')) {
        result['name'] = 'node.js';
        result['confidence'] = 50;
        return result;
      }
    }
  } catch (_) {
    // ignore
  }
  return result;
}

List<String> detectWafCdns(Map<String, String>? headers, String? cname) {
  final found = <String>{};
  try {
    if (headers != null) {
      final lower = <String, String>{};
      for (final e in headers.entries) {
        lower[e.key.toLowerCase()] = e.value.toLowerCase();
      }
      if (lower.containsKey('server') && lower['server']!.contains('vercel')) {
        found.add('Vercel');
      }
      if (lower.containsKey('x-vercel-id')) found.add('Vercel');
      if (lower.containsKey('server') &&
          lower['server']!.contains('cloudflare')) {
        found.add('Cloudflare');
      }
      if (lower.containsKey('cf-ray') || lower.containsKey('cf-cache-status')) {
        found.add('Cloudflare');
      }
      if (lower.containsKey('server') && lower['server']!.contains('akamai')) {
        found.add('Akamai');
      }
      if (lower.containsKey('via') && lower['via']!.contains('varnish')) {
        found.add('Varnish/CDN');
      }
      if (lower.containsKey('server') && lower['server']!.contains('fastly')) {
        found.add('Fastly');
      }
      if (lower.containsKey('x-amz-cf-id')) found.add('CloudFront');
      if (lower.containsKey('x-powered-by') &&
          lower['x-powered-by']!.contains('next')) {
        found.add('Next.js');
      }
    }
    if (cname != null && cname.isNotEmpty) {
      final cn = cname.toLowerCase();
      if (cn.endsWith('.vercel.app') || cn.contains('.now.sh')) {
        found.add('Vercel');
      }
      if (cn.endsWith('.cdn.cloudflare.net') || cn.contains('cloudflare')) {
        found.add('Cloudflare');
      }
      if (cn.contains('akamai') || cn.endsWith('.akamaized.net')) {
        found.add('Akamai');
      }
      if (cn.endsWith('.netlify.app') || cn.contains('netlify')) {
        found.add('Netlify');
      }
      if (cn.endsWith('.cloudfront.net')) found.add('CloudFront');
    }
  } catch (_) {}
  return found.toList();
}
