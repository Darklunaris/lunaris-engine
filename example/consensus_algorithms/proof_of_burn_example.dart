import 'package:lunaris_engine/Consensus/proof_of_burn.dart';

void main() {
  final pob = PoB();
  pob.applyBurn(BurnEvent('alice', 100, 1));
  pob.applyBurn(BurnEvent('bob', 50, 2));
  print('alice weight=${pob.weight('alice')} bob=${pob.weight('bob')}');
}
