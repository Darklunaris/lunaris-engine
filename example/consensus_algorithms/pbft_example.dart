import 'package:lunaris_engine/Consensus/pbft.dart';

void main() {
  final pbft = PBFT(4, 1);
  print('canCommit=${pbft.canCommit(2, 3)}');
}
