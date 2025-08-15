import 'package:lunaris_engine/Consensus/fba.dart';

void main() {
  final slices = {
    'A': [
      {'A', 'B'},
      {'A', 'C'},
    ],
    'B': [
      {'A', 'B'},
    ],
    'C': [
      {'A', 'C'},
    ],
  };
  final fba = FBA(
    slices.map(
      (k, v) => MapEntry(k, v.map((s) => Set<String>.from(s)).toList()),
    ),
  );
  print('quorum=${fba.isQuorum({'A', 'B'})}');
}
