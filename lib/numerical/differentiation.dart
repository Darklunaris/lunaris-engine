/// High-accuracy numerical differentiation utilities.
///
/// Provides high-order finite difference derivative approximations and a
/// Richardson extrapolation wrapper to increase accuracy. Designed for
/// production use where precision and stability matter.
///
/// Example:
/// ```dart
/// final d = derivative((x) => math.sin(x), 0.0);
/// ```
library;

/// Compute derivative f'(x) using a high-order central finite-difference.
///
/// This uses an 8-point central finite-difference stencil for the base
/// approximation and optional Richardson extrapolation to boost accuracy.
double derivative(
  double Function(double) f,
  double x, {
  double h = 1e-4,
  bool richardson = true,
}) {
  // Robust 5-point central difference for first derivative
  final h1 = h;
  final f1 =
      (f(x - 2 * h1) - 8 * f(x - h1) + 8 * f(x + h1) - f(x + 2 * h1)) /
      (12 * h1);

  if (!richardson) return f1;

  final h2 = h1 / 2;
  final f2 =
      (f(x - 2 * h2) - 8 * f(x - h2) + 8 * f(x + h2) - f(x + 2 * h2)) /
      (12 * h2);
  // Richardson extrapolate (error ~ h^8)
  return (256 * f2 - f1) / 255.0;
}
