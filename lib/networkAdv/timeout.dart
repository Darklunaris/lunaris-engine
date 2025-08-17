final Map<String, double> _rttEwma = {};
const double _rttAlpha = 0.2;

Duration adaptiveTimeoutForHost(String host, Duration base) {
  final avg = _rttEwma[host];
  if (avg == null || avg.isNaN || avg <= 0) return base;
  final ms = (avg * 4).clamp(50, 2000);
  return Duration(milliseconds: ms.toInt());
}

void updateRtt(String host, double sampleMs) {
  final prev = _rttEwma[host] ?? sampleMs;
  _rttEwma[host] = (1 - _rttAlpha) * prev + _rttAlpha * sampleMs;
}
