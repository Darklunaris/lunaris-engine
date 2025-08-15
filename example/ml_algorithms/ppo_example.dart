import 'package:lunaris_engine/MachineLearning/ppo.dart';

void main() {
  final p = PPO(
    nActions: 2,
    actorLayers: [3, 8, 2],
    criticLayers: [3, 8, 1],
    seed: 1,
  );
  final a = p.selectAction([0.0, 0.0, 0.0]);
  print('action=$a');
}
