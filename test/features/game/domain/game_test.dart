import 'package:flutter_test/flutter_test.dart';
import 'package:score_beloty_2_0/features/game/domain/deal.dart';
import 'package:score_beloty_2_0/features/game/domain/game.dart';
import 'package:score_beloty_2_0/features/game/domain/rules.dart';
import 'package:score_beloty_2_0/features/game/domain/team.dart';

const _teams = (
  us: Team(player1: 'A', player2: 'B'),
  them: Team(player1: 'C', player2: 'D'),
);

Game _newGame({Rules? rules}) => Game.fresh(
      us: _teams.us,
      them: _teams.them,
      rules: rules ?? const Rules(),
    );

Deal _finishedDeal({
  required int ours,
  required int theirs,
  BidType bid = BidType.pass,
  ResultType result = ResultType.weWin,
}) {
  return Deal(
    contract: ContractType.allTrumps,
    bid: bid,
    beginAt: DateTime(2026, 1, 1),
    result: result,
    ourPoints: ours,
    theirPoints: theirs,
  );
}

void main() {
  group('Game', () {
    test('starts with zero scores', () {
      final g = _newGame();
      expect(g.ourScore, 0);
      expect(g.theirScore, 0);
      expect(g.isOver, isFalse);
      expect(g.winner, Winner.none);
      expect(g.currentDeal, isNull);
      expect(g.state, GameState.begin);
    });

    test('addDeal returns new Game instance and tracks running state', () {
      final g = _newGame().addDeal(_finishedDeal(ours: 50, theirs: 0));
      expect(g.ourScore, 50);
      expect(g.theirScore, 0);
      expect(g.state, GameState.running);
    });

    test('ourScore sums finished deals and ignores unfinished', () {
      final g0 = _newGame()
          .addDeal(_finishedDeal(ours: 50, theirs: 0))
          .addDeal(_finishedDeal(ours: 80, theirs: 20))
          .addDeal(Deal(
            contract: ContractType.allTrumps,
            bid: BidType.pass,
            beginAt: DateTime(2026, 1, 2),
          ));
      expect(g0.ourScore, 130);
      expect(g0.theirScore, 20);
    });

    test('isOver when a team reaches finalScore', () {
      final g = _newGame().addDeal(_finishedDeal(ours: 162, theirs: 0));
      expect(g.isOver, isTrue);
      expect(g.winner, Winner.us);
    });

    test('winner is them when theirScore crosses threshold first', () {
      final g = _newGame().addDeal(_finishedDeal(
        ours: 50,
        theirs: 162,
        result: ResultType.theyWin,
      ));
      expect(g.isOver, isTrue);
      expect(g.winner, Winner.them);
    });

    test('continueAfterTie raises target when scores are tied', () {
      final g0 = _newGame().addDeal(_finishedDeal(ours: 50, theirs: 50));
      expect(g0.targetScore, 150);
      final g1 = g0.continueAfterTie();
      expect(g1.targetScore, 200);
      expect(g0.targetScore, 150, reason: 'original unchanged');
    });

    test('continueAfterTie is a no-op when continueOnTie is disabled', () {
      final g0 = _newGame(rules: const Rules(continueOnTie: false))
          .addDeal(_finishedDeal(ours: 50, theirs: 50));
      final g1 = g0.continueAfterTie();
      expect(g1.targetScore, 150);
    });

    test('removeLastDeal removes and returns last deal', () {
      final g0 = _newGame().addDeal(_finishedDeal(ours: 100, theirs: 0));
      final g1 = g0.removeLastDeal();
      expect(g1, isNotNull);
      expect(g1!.deals, isEmpty);
      expect(g1.ourScore, 0);
      expect(g1.raisedTarget, isNull);
    });

    test('removeLastDeal returns null on empty game', () {
      expect(_newGame().removeLastDeal(), isNull);
    });

    test('markFinishedIfNeeded flips state when isOver', () {
      final g0 = _newGame().addDeal(_finishedDeal(ours: 162, theirs: 0));
      expect(g0.state, GameState.running);
      final g1 = g0.markFinishedIfNeeded();
      expect(g1.state, GameState.finished);
    });

    test('json roundtrip preserves deals and raised target', () {
      final g0 = _newGame()
          .addDeal(_finishedDeal(ours: 80, theirs: 40))
          .continueAfterTie();
      final restored = Game.fromJson(g0.toJson());
      expect(restored.ourScore, g0.ourScore);
      expect(restored.deals.length, 1);
      expect(restored.targetScore, g0.targetScore);
    });
  });
}
