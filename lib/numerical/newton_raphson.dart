/// High-performance Newton–Raphson root finder with optional numeric derivative.
///
/// This implementation is written for production use: it performs a guarded
/// iteration with optional analytic derivative fallback, configurable
/// tolerances, and a robust step limit. It accepts generic numeric types but
/// converts to `double` internally for numeric performance and interoperability.
///
/// Example usage:
/// ```dart
/// final root = newtonRaphson((x) => x * x - 2, null, 1.0);
/// ```
double newtonRaphson<T extends num>(
  double Function(double x) f,
  double Function(double x)? df,
  T initialGuess, {
  int maxIter = 100,
  double tol = 1e-12,
  double epsDerivative = 1e-12,
}) {
  var x = initialGuess.toDouble();
  for (var i = 0; i < maxIter; i++) {
    final fx = f(x);
    final derivative =
        df != null ? df(x) : _numericDerivative(f, x, eps: epsDerivative);
    if (derivative == 0.0 || derivative.isNaN) {
      x += tol; // perturb and try again
      continue;
    }
    final dx = fx / derivative;
    x -= dx;
    if (dx.abs() <= tol * (1.0 + x.abs())) {
      return x;
    }
  }
  throw StateError('Newton–Raphson did not converge in $maxIter iterations');
}

double _numericDerivative(
  double Function(double) f,
  double x, {
  double eps = 1e-8,
}) {
  // Five-point central difference for higher accuracy.
  final h = eps * (1.0 + x.abs());
  final f1 = f(x - 2 * h);
  final f2 = f(x - h);
  final f3 = f(x + h);
  final f4 = f(x + 2 * h);
  return (f1 - 8 * f2 + 8 * f3 - f4) / (12 * h);
}
