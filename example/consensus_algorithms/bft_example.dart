import 'package:lunaris_engine/Consensus/bft.dart';

void main() {
  final b = BFT(4, 1);
  final votes = {0: true, 1: true, 2: false, 3: true};
  print('commit=${b.commit(votes)}');
}
