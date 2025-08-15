import 'package:lunaris_engine/Consensus/proof_of_authority.dart';

void main() {
  final auths = [
    Authority('A', weight: 1),
    Authority('B', weight: 2),
    Authority('C', weight: 1),
  ];
  final poa = PoA(auths);
  print('leader0=${poa.leaderForSlot(0)} leader3=${poa.leaderForSlot(3)}');
}
