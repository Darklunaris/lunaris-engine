import 'package:lunaris_engine/Consensus/delegated_proof_of_stake.dart';

void main() {
  final delegates = [
    Delegate('p1', 100),
    Delegate('p2', 50),
    Delegate('p3', 75),
  ];
  final dpos = DPoS(delegates);
  final schedule = dpos.scheduleForSlots(10);
  print('schedule=$schedule');
}
