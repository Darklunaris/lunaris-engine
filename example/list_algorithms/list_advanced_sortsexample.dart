// import 'package:lunaris_engine/list_advanced_sorts/heap_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/shell_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/gnome_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/odd_even_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/pancake_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/cycle_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/bucket_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/radix_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/pigeonhole_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/bitonic_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/comb_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/stooge_sort.dart';
// import 'package:lunaris_engine/list_advanced_sorts/quickselect.dart';
// import 'package:lunaris_engine/list_advanced_sorts/lis_binary_search.dart';
// import 'package:lunaris_engine/list_advanced_sorts/max_product_subarray.dart';
import 'package:lunaris_engine/lunaris_engine.dart';

void main() {
  // 🥔 Heap Sort
  var arr1 = [4, 10, 3, 5, 1];
  heapSort(arr1);
  print('Heap Sort: $arr1');

  // 🐚 Shell Sort
  var arr2 = [12, 34, 54, 2, 3];
  shellSort(arr2);
  print('Shell Sort: $arr2');

  // 🦩 Gnome Sort
  var arr3 = [34, 2, 10, -9];
  gnomeSort(arr3);
  print('Gnome Sort: $arr3');

  // 🟣 Odd-Even Sort
  var arr4 = [5, 3, 2, 4, 1];
  oddEvenSort(arr4);
  print('Odd-Even Sort: $arr4');

  // 🥞 Pancake Sort
  var arr5 = [3, 6, 1, 10, 2];
  pancakeSort(arr5);
  print('Pancake Sort: $arr5');

  // 🔄 Cycle Sort
  var arr6 = [20, 40, 50, 10, 30];
  cycleSort(arr6);
  print('Cycle Sort: $arr6');

  // 🪣 Bucket Sort
  var arr7 = [0.42, 4.21, 3.14, 2.71, 1.61, 0.99];
  bucketSort(arr7);
  print('Bucket Sort: $arr7');

  // 🧮 Radix Sort
  var arr8 = [170, 45, 75, 90, 802, 24, 2, 66];
  radixSort(arr8);
  print('Radix Sort: $arr8');

  // 🕳️ Pigeonhole Sort
  var arr9 = [8, 3, 2, 7, 4, 6, 8];
  pigeonholeSort(arr9);
  print('Pigeonhole Sort: $arr9');

  // 🔀 Bitonic Sort
  var arr10 = [3, 7, 4, 8];
  bitonicSort(arr10, ascending: true);
  print('Bitonic Sort: $arr10');

  // 🐓 Comb Sort
  var arr11 = [8, 4, 1, 56, 3, -44, 23, -6, 28, 0];
  combSort(arr11);
  print('Comb Sort: $arr11');

  // 🧙 Stooge Sort
  var arr12 = [2, 4, 5, 3, 1];
  stoogeSort(arr12);
  print('Stooge Sort: $arr12');

  // ⚡ Quickselect
  var arr13 = [7, 10, 4, 3, 20, 15];
  print('Quickselect (2nd smallest): ${quickselect(List<int>.from(arr13), 2)}');

  // 📈 LIS (O(n log n))
  print('LIS Binary Search: ${lisBinarySearch([10, 9, 2, 5, 3, 7, 101, 18])}');

  // 💹 Maximum Product Subarray
  print('Max Product Subarray: ${maxProductSubarray([2.0, 3.0, -2.0, 4.0])}');
}
