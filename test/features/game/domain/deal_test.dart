import 'package:flutter_test/flutter_test.dart';
import 'package:score_beloty_2_0/features/game/domain/deal.dart';

void main() {
  group('Deal', () {
    final base = DateTime(2026, 1, 1, 10);

    test('default deal is unfinished with no capot', () {
      final d = Deal(
        contract: ContractType.allTrumps,
        bid: BidType.pass,
        beginAt: base,
      );
      expect(d.result, isNull);
      expect(d.isFinished, isFalse);
      expect(d.capot, CapotType.no);
      expect(d.ourPoints, 0);
      expect(d.theirPoints, 0);
      expect(d.tie, isFalse);
    });

    test('json roundtrip preserves deal state', () {
      final d = Deal(
        contract: ContractType.spades,
        bid: BidType.double_,
        beginAt: base,
        capot: CapotType.capot,
        result: ResultType.weWin,
        ourPoints: 162,
        theirPoints: 0,
        tie: false,
      );
      expect(Deal.fromJson(d.toJson()), equals(d));
    });

    test('copyWith clears result when requested', () {
      final d = Deal(
        contract: ContractType.allTrumps,
        bid: BidType.pass,
        beginAt: base,
        result: ResultType.weWin,
        ourPoints: 100,
      );
      final cleared = d.copyWith(clearResult: true);
      expect(cleared.result, isNull);
      expect(cleared.ourPoints, d.ourPoints);
    });
  });
}
