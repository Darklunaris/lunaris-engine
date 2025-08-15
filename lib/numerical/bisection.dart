/// Robust Bisection root finder.
///
/// The bisection method is guaranteed to converge when provided an interval
/// [a,b] such that f(a) and f(b) have opposite signs. This implementation
/// performs safe midpoint selection and allows configurable tolerances.
///
/// Returns the root as a `double` or throws [ArgumentError] if the signs don't
/// bracket a root.
double bisection<T extends num>(
  double Function(double x) f,
  T a,
  T b, {
  int maxIter = 200,
  double tol = 1e-12,
}) {
  var lo = a.toDouble();
  var hi = b.toDouble();
  var flo = f(lo);
  var fhi = f(hi);
  if (flo == 0.0) return lo;
  if (fhi == 0.0) return hi;
  if (flo.sign == fhi.sign) {
    throw ArgumentError(
      'Function values at endpoints must have opposite signs',
    );
  }
  for (var i = 0; i < maxIter; i++) {
    final mid = 0.5 * (lo + hi);
    final fmid = f(mid);
    if (fmid == 0.0 || (hi - lo) / 2 <= tol) return mid;
    if (fmid.sign == flo.sign) {
      lo = mid;
      flo = fmid;
    } else {
      hi = mid;
      fhi = fmid;
    }
  }
  return 0.5 * (lo + hi);
}
