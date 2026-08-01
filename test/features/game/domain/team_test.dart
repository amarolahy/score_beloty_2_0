import 'package:flutter_test/flutter_test.dart';
import 'package:score_beloty_2_0/features/game/domain/team.dart';

void main() {
  group('Team', () {
    test('initial score defaults to 0', () {
      const t = Team(player1: 'A', player2: 'B');
      expect(t.initialScore, 0);
    });

    test('equality based on fields', () {
      const a = Team(player1: 'A', player2: 'B', initialScore: 10);
      const b = Team(player1: 'A', player2: 'B', initialScore: 10);
      expect(a, equals(b));
    });

    test('json roundtrip preserves values', () {
      const t = Team(player1: 'Alice', player2: 'Bob', initialScore: 50);
      expect(Team.fromJson(t.toJson()), equals(t));
    });
  });
}
