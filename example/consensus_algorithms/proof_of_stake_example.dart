import 'package:lunaris_engine/Consensus/proof_of_stake.dart';

void main() {
  final vals = [Validator('A', 10), Validator('B', 20), Validator('C', 5)];
  final pos = PoS(vals);
  print('proposer=${pos.selectProposer(1).id}');
  pos.slash('B', 5);
  print('B stake=${vals[1].stake}');
}
