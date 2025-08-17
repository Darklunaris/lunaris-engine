import 'dart:io';

/// Inspect TLS certificate information for a host:port. Same semantics as the
/// original inline implementation in scanner.dart: returns null on error.
Future<Map<String, dynamic>?> inspectTlsCertificate(
  String host,
  int port, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  try {
    final socket = await SecureSocket.connect(
      host,
      port,
      onBadCertificate: (_) => true,
      timeout: timeout,
    );
    final cert = socket.peerCertificate;
    socket.destroy();
    if (cert == null) return null;
    return {
      'subject': cert.subject,
      'issuer': cert.issuer,
      'start': cert.startValidity.toIso8601String(),
      'end': cert.endValidity.toIso8601String(),
      'sha1': cert.sha1,
    };
  } catch (_) {
    return null;
  }
}
