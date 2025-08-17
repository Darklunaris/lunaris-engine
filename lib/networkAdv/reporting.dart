Map<String, dynamic> severitySummary(
  Map<String, Map<int, Map<String, dynamic>>> results,
) {
  final counts = <String, int>{};
  int highestScore = 0;
  String? highestHost;
  int? highestPort;
  for (final hostEntry in results.entries) {
    for (final portEntry in hostEntry.value.entries) {
      final sev = portEntry.value['severity'];
      if (sev is Map && sev['level'] is String) {
        final lvl = sev['level'] as String;
        counts[lvl] = (counts[lvl] ?? 0) + 1;
        final score = (sev['score'] is int) ? sev['score'] as int : 0;
        if (score > highestScore) {
          highestScore = score;
          highestHost = hostEntry.key;
          highestPort = portEntry.key;
        }
      }
    }
  }
  return {
    'counts': counts,
    'highest':
        highestScore > 0
            ? {'score': highestScore, 'host': highestHost, 'port': highestPort}
            : null,
  };
}
