import 'package:test/test.dart';
import 'package:lunaris_engine/map/word_frequency_ranking.dart';

void main() {
  test('wordFrequencyRanking basic', () {
    final text = 'the quick brown fox jumps over the lazy dog the quick';
    final result = wordFrequencyRanking(text);
    expect(result.first, equals('the'));
    expect(result[1], equals('quick'));
    expect(
      result,
      containsAll(['fox', 'jumps', 'over', 'lazy', 'dog', 'brown']),
    );
  });
}
