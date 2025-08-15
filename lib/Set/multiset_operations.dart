/// Implements a MultiSet (Bag) with union, intersection, difference, and count operations.
///
/// A MultiSet allows duplicate elements. This implementation uses a map to track element counts.
///
/// - `add(value, [count])`: Adds [value] to the multiset [count] times (default 1).
/// - `remove(value, [count])`: Removes [value] from the multiset [count] times (default 1).
/// - `count(value)`: Returns the count of [value] in the multiset.
/// - `union(other)`: Returns a new MultiSet that is the union of this and [other].
/// - `intersection(other)`: Returns a new MultiSet that is the intersection of this and [other].
/// - `difference(other)`: Returns a new MultiSet that is the difference of this and [other].
///
/// Time Complexity: O(n) for most operations, where n is the number of unique elements.
/// Space Complexity: O(n)
///
/// Example:
/// ```dart
/// final ms1 = MultiSet<int>([1, 2, 2, 3]);
/// final ms2 = MultiSet<int>([2, 3, 3, 4]);
/// print(ms1.union(ms2)); // Outputs: {1: 1, 2: 3, 3: 3, 4: 1}
/// print(ms1.intersection(ms2)); // Outputs: {2: 1, 3: 1}
/// print(ms1.difference(ms2)); // Outputs: {1: 1}
/// ```
class MultiSet<T> {
  final Map<T, int> _elements = {};

  MultiSet([Iterable<T>? items]) {
    if (items != null) {
      for (final item in items) {
        add(item);
      }
    }
  }

  void add(T value, [int count = 1]) {
    _elements.update(value, (c) => c + count, ifAbsent: () => count);
  }

  bool remove(T value, [int count = 1]) {
    if (!_elements.containsKey(value)) return false;
    final newCount = _elements[value]! - count;
    if (newCount > 0) {
      _elements[value] = newCount;
      return true;
    } else {
      _elements.remove(value);
      return true;
    }
  }

  int count(T value) => _elements[value] ?? 0;

  int get length => _elements.values.fold(0, (a, b) => a + b);

  Set<T> toSet() => _elements.keys.toSet();

  MultiSet<T> union(MultiSet<T> other) {
    final result = MultiSet<T>();
    for (final key in _elements.keys) {
      result._elements[key] = _elements[key]!;
    }
    for (final key in other._elements.keys) {
      result._elements[key] =
          (result._elements[key] ?? 0) + other._elements[key]!;
    }
    return result;
  }

  MultiSet<T> intersection(MultiSet<T> other) {
    final result = MultiSet<T>();
    for (final key in _elements.keys) {
      if (other._elements.containsKey(key)) {
        result._elements[key] = _elements[key]!.clamp(0, other._elements[key]!);
      }
    }
    return result;
  }

  MultiSet<T> difference(MultiSet<T> other) {
    final result = MultiSet<T>();
    for (final key in _elements.keys) {
      final diff = _elements[key]! - (other._elements[key] ?? 0);
      if (diff > 0) {
        result._elements[key] = diff;
      }
    }
    return result;
  }

  @override
  String toString() => _elements.toString();
}
