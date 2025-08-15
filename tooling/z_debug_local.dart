void main() {
  final s = 'aabcaabxaaaz';
  final n = s.length;
  final z = List<int>.filled(n, 0);
  int l = 0, r = 0;
  for (int i = 1; i < n; i++) {
    int k = 0;
    if (i <= r) k = (z[i - l] < r - i + 1) ? z[i - l] : (r - i + 1);
    while (i + k < n && s[k] == s[i + k]) {
      k++;
    }
    z[i] = k;
    if (i + k - 1 > r) {
      l = i;
      r = i + k - 1;
    }
  }
  print(z);
}
