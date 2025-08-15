// import 'package:lunaris_engine/set_algorithms/symmetric_difference.dart';
// import 'package:lunaris_engine/set_algorithms/power_set.dart';
// import 'package:lunaris_engine/set_algorithms/subset_check.dart';
// import 'package:lunaris_engine/set_algorithms/superset_check.dart';
// import 'package:lunaris_engine/set_algorithms/disjoint_check.dart';
// import 'package:lunaris_engine/set_algorithms/list_to_set_preserve_order.dart';
// import 'package:lunaris_engine/set_algorithms/multiset_operations.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  // Symmetric Difference
  final setA = {1, 2, 3};
  final setB = {3, 4, 5};
  print(
    'Symmetric Difference: ${symmetricDifference(setA, setB)}',
  ); // {1, 2, 4, 5}

  // Power Set
  final setC = {1, 2};
  print('Power Set: ${powerSet(setC)}'); // {{}, {1}, {2}, {1, 2}}

  // Subset Check
  print('isSubset({1, 2}, {1, 2, 3}): ${isSubset({1, 2}, {1, 2, 3})}'); // true

  // Superset Check
  print(
    'isSuperset({1, 2, 3}, {2, 3}): ${isSuperset({1, 2, 3}, {2, 3})}',
  ); // true

  // Disjoint Check
  print('isDisjoint({1, 2}, {3, 4}): ${isDisjoint({1, 2}, {3, 4})}'); // true

  // Convert List to Set while preserving order
  final list = [3, 1, 2, 3, 2];
  print(
    'List to Set (preserve order): ${listToSetPreserveOrder(list)}',
  ); // [3, 1, 2]

  // MultiSet (Bag) Operations
  final bag1 = MultiSet<String>(['a', 'b', 'a']);
  final bag2 = MultiSet<String>(['a', 'c']);
  print('MultiSet bag1: $bag1');
  print('MultiSet bag2: $bag2');
  print('Union: ${bag1.union(bag2)}');
  print('Intersection: ${bag1.intersection(bag2)}');
  print('Difference: ${bag1.difference(bag2)}');
}
