import 'package:test/test.dart';
import 'package:lunaris_engine/MachineLearning/mcts.dart';

bool isTerminal(int s) => s.abs() >= 2;
List<dynamic> expand(int s) => [-1, 1];
int nextState(int s, action) => s + (action as int);
double reward(int s) => s.toDouble();

void main() {
  group('MCTS', () {
    test('search returns an action or null', () {
      final mcts = MCTS<int>(
        isTerminal: isTerminal,
        expand: expand,
        nextState: nextState,
        reward: reward,
        seed: 2,
      );
      final a = mcts.search(0, iterations: 20);
      expect(a == null || a == -1 || a == 1, isTrue);
    });
  });
}
