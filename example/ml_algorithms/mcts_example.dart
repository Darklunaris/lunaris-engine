import 'package:lunaris_engine/MachineLearning/mcts.dart';

// small 1D game: state is int, actions = decrement or increment
bool isTerminal(int s) => s.abs() >= 3;
List<dynamic> expand(int s) => [-1, 1];
int nextState(int s, action) => s + (action as int);
double reward(int s) => s.toDouble();

void main() {
  final mcts = MCTS<int>(
    isTerminal: isTerminal,
    expand: expand,
    nextState: nextState,
    reward: reward,
    seed: 1,
  );
  final a = mcts.search(0, iterations: 50);
  print('best=$a');
}
