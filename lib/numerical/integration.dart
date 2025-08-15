/// Numerical integration utilities with high-quality composite rules.
///
/// Includes adaptive Simpson and Gauss–Legendre (fixed order) integrators.
/// Implementations focus on numerical stability and performance for real-valued
/// integrands and large-scale usage.
///
/// Example:
/// ```dart
/// final integral = adaptiveSimpson((x) => x * x, 0.0, 1.0);
/// ```
library;

/// Adaptive Simpson integrator.
///
/// High-accuracy adaptive Simpson that recursively subdivides intervals
/// until the requested tolerance is reached. Suitable for smooth integrands
/// and robust enough for production workloads.
double adaptiveSimpson(
  double Function(double) f,
  double a,
  double b, {
  double tol = 1e-12,
  int maxRecursion = 20,
}) {
  double simpson(double fa, double fm, double fb, double h) =>
      (fa + 4 * fm + fb) * h / 6.0;

  double recurse(
    double a,
    double b,
    double fa,
    double fb,
    double fm,
    double whole,
    int depth,
  ) {
    final m = 0.5 * (a + b);
    final lm = 0.5 * (a + m);
    final rm = 0.5 * (m + b);
    final flm = f(lm);
    final frm = f(rm);
    final left = simpson(fa, flm, fm, (m - a));
    final right = simpson(fm, frm, fb, (b - m));
    final delta = left + right - whole;
    if (delta.abs() <= 15 * tol || depth >= maxRecursion) {
      return left + right + delta / 15.0;
    }
    return recurse(a, m, fa, fm, flm, left, depth + 1) +
        recurse(m, b, fm, fb, frm, right, depth + 1);
  }

  final fa = f(a);
  final fb = f(b);
  final m = 0.5 * (a + b);
  final fm = f(m);
  final whole = (fa + 4 * fm + fb) * (b - a) / 6.0;
  return recurse(a, b, fa, fb, fm, whole, 0);
}

/// Gauss-Legendre fixed order integrator (orders 2..5).
double gaussLegendreFixedOrder(
  double Function(double) f,
  double a,
  double b, {
  int order = 5,
}) {
  final nodesAndWeights = {
    2: [
      [-0.5773502691896257, 1.0],
      [0.5773502691896257, 1.0],
    ],
    3: [
      [0.0, 1.3333333333333333],
      [-0.7745966692414834, 0.5555555555555556],
      [0.7745966692414834, 0.5555555555555556],
    ],
    4: [
      [-0.3399810435848563, 0.6521451548625461],
      [0.3399810435848563, 0.6521451548625461],
      [-0.8611363115940526, 0.3478548451374538],
      [0.8611363115940526, 0.3478548451374538],
    ],
    5: [
      [0.0, 0.5688888888888889],
      [-0.5384693101056831, 0.47862867049936647],
      [0.5384693101056831, 0.47862867049936647],
      [-0.9061798459386640, 0.23692688505618908],
      [0.9061798459386640, 0.23692688505618908],
    ],
  };
  final list = nodesAndWeights[order];
  if (list == null) throw ArgumentError('Order $order not supported');
  final mid = 0.5 * (a + b);
  final half = 0.5 * (b - a);
  var sum = 0.0;
  for (final nw in list) {
    final x = mid + half * (nw[0]);
    final w = nw[1];
    sum += w * f(x);
  }
  return half * sum;
}
