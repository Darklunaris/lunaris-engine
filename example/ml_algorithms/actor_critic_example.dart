import 'package:lunaris_engine/MachineLearning/actor_critic.dart';

void main() {
  final ac = ActorCritic(
    nActions: 2,
    actorLayers: [3, 8, 2],
    criticLayers: [3, 8, 1],
    seed: 1,
  );
  final a = ac.selectAction([0.0, 0.0, 0.0]);
  print('action=$a');
}
