import 'package:flutter_test/flutter_test.dart';
import 'package:score_beloty_2_0/features/game/domain/deal.dart';
import 'package:score_beloty_2_0/features/game/domain/rules.dart';
import 'package:score_beloty_2_0/features/game/domain/scoring.dart';

void main() {
  group('ScoringEngine.dedansPoints', () {
    test('returns 26 for all trumps', () {
      expect(ScoringEngine.dedansPoints(ContractType.allTrumps), 26);
    });

    test('returns 52 for no trumps', () {
      expect(ScoringEngine.dedansPoints(ContractType.noTrumps), 52);
    });

    test('returns 16 for spades/hearts/diamonds', () {
      expect(ScoringEngine.dedansPoints(ContractType.spades), 16);
      expect(ScoringEngine.dedansPoints(ContractType.hearts), 16);
      expect(ScoringEngine.dedansPoints(ContractType.diamonds), 16);
    });

    test('returns 32 for clubs', () {
      expect(ScoringEngine.dedansPoints(ContractType.clubs), 32);
    });

    test('returns 0 for error contract', () {
      expect(ScoringEngine.dedansPoints(ContractType.error), 0);
    });
  });

  group('ScoringEngine.capotPoints', () {
    const rules = Rules(finalScore: 150);

    test('all trumps capot = 35', () {
      expect(ScoringEngine.capotPoints(ContractType.allTrumps, rules), 35);
    });

    test('no trumps capot = 90', () {
      expect(ScoringEngine.capotPoints(ContractType.noTrumps, rules), 90);
    });

    test('color capot uses finalScore when not predefined', () {
      expect(ScoringEngine.capotPoints(ContractType.spades, rules), 150);
      expect(ScoringEngine.capotPoints(ContractType.clubs, rules), 150);
    });
  });

  group('ScoringEngine.capotInsidePoints', () {
    const rules = Rules(finalScore: 150);

    test('all trumps capotInside = 45', () {
      expect(
        ScoringEngine.capotInsidePoints(ContractType.allTrumps, rules),
        45,
      );
    });

    test('no trumps capotInside = 120', () {
      expect(
        ScoringEngine.capotInsidePoints(ContractType.noTrumps, rules),
        120,
      );
    });

    test('color capotInside uses finalScore', () {
      expect(
        ScoringEngine.capotInsidePoints(ContractType.spades, rules),
        150,
      );
    });

    test('winIfCapotInside shortcut returns finalScore directly', () {
      const rulesSpecial = Rules(winIfCapotInside: true, finalScore: 150);
      expect(
        ScoringEngine.capotInsidePoints(ContractType.allTrumps, rulesSpecial),
        150,
      );
    });
  });

  group('ScoringEngine.bidMultiplier', () {
    const rules = Rules();

    test('pass returns 1', () {
      expect(
        ScoringEngine.bidMultiplier(BidType.pass, ContractType.allTrumps, rules),
        1,
      );
    });

    test('double returns 2 for color contracts', () {
      expect(
        ScoringEngine.bidMultiplier(
            BidType.double_, ContractType.spades, rules),
        2,
      );
    });

    test('redouble returns 4 for color contracts', () {
      expect(
        ScoringEngine.bidMultiplier(
            BidType.redouble, ContractType.spades, rules),
        4,
      );
    });

    test('double on no trumps returns 1 when redoubleNoTrumps disabled', () {
      expect(
        ScoringEngine.bidMultiplier(
            BidType.double_, ContractType.noTrumps, rules),
        1,
      );
    });

    test('double on no trumps returns 2 when redoubleNoTrumps enabled', () {
      const rulesSpecial = Rules(redoubleNoTrumps: true);
      expect(
        ScoringEngine.bidMultiplier(
            BidType.double_, ContractType.noTrumps, rulesSpecial),
        2,
      );
    });
  });

  group('ScoringEngine.computeTotal', () {
    const rules = Rules(finalScore: 150);

    test('dedans all trumps doubled = 52', () {
      expect(
        ScoringEngine.computeTotal(
          contract: ContractType.allTrumps,
          bid: BidType.double_,
          capot: CapotType.no,
          rules: rules,
        ),
        52,
      );
    });

    test('capot all trumps redoubled = 140', () {
      expect(
        ScoringEngine.computeTotal(
          contract: ContractType.allTrumps,
          bid: BidType.redouble,
          capot: CapotType.capot,
          rules: rules,
        ),
        140,
      );
    });

    test('capot inside color redoubled = 600', () {
      expect(
        ScoringEngine.computeTotal(
          contract: ContractType.spades,
          bid: BidType.redouble,
          capot: CapotType.capotInside,
          rules: rules,
        ),
        600,
      );
    });
  });

  group('ScoringEngine.isSplitAllowed', () {
    const defaultRules = Rules();

    test('all trumps follows splitAllTrumps rule', () {
      expect(ScoringEngine.isSplitAllowed(ContractType.allTrumps, defaultRules),
          isTrue);
      expect(
        ScoringEngine.isSplitAllowed(
          ContractType.allTrumps,
          const Rules(splitAllTrumps: false),
        ),
        isFalse,
      );
    });

    test('no trumps follows splitNoTrumps rule', () {
      expect(ScoringEngine.isSplitAllowed(ContractType.noTrumps, defaultRules),
          isFalse);
      expect(
        ScoringEngine.isSplitAllowed(
          ContractType.noTrumps,
          const Rules(splitNoTrumps: true),
        ),
        isTrue,
      );
    });

    test('color follows splitColor rule', () {
      expect(
        ScoringEngine.isSplitAllowed(ContractType.spades, defaultRules),
        isFalse,
      );
      expect(
        ScoringEngine.isSplitAllowed(
          ContractType.spades,
          const Rules(splitColor: true),
        ),
        isTrue,
      );
    });
  });

  group('DealOutcome', () {
    test('usWin sets result and clears their points', () {
      final outcome = DealOutcome.usWin(120);
      expect(outcome.result, ResultType.weWin);
      expect(outcome.ourPoints, 120);
      expect(outcome.theirPoints, 0);
      expect(outcome.tie, isFalse);
    });

    test('themWin sets result and clears our points', () {
      final outcome = DealOutcome.themWin(80);
      expect(outcome.result, ResultType.theyWin);
      expect(outcome.ourPoints, 0);
      expect(outcome.theirPoints, 80);
      expect(outcome.tie, isFalse);
    });

    test('split records both scores', () {
      final outcome = DealOutcome.split(14, 12);
      expect(outcome.result, ResultType.split);
      expect(outcome.ourPoints, 14);
      expect(outcome.theirPoints, 12);
      expect(outcome.tie, isFalse);
    });

    test('litigation marks tie when both sides match', () {
      final outcome = DealOutcome.litigation(81, 81);
      expect(outcome.result, ResultType.litigation);
      expect(outcome.ourPoints, 81);
      expect(outcome.theirPoints, 81);
      expect(outcome.tie, isTrue);
    });

    test('toDeal produces a Deal reflecting the outcome', () {
      final outcome = DealOutcome.usWin(162);
      final deal = outcome.toDeal(
        beginAt: DateTime(2026, 6, 1),
        contract: ContractType.spades,
        bid: BidType.pass,
      );
      expect(deal.contract, ContractType.spades);
      expect(deal.bid, BidType.pass);
      expect(deal.result, ResultType.weWin);
      expect(deal.ourPoints, 162);
      expect(deal.theirPoints, 0);
      expect(deal.tie, isFalse);
      expect(deal.isFinished, isTrue);
    });
  });
}
