import 'package:flutter_test/flutter_test.dart';
import 'package:score_beloty_2_0/features/game/domain/rules.dart';

void main() {
  group('Rules', () {
    test('defaults match belote Malagasy conventions', () {
      const r = Rules();
      expect(r.finalScore, 150);
      expect(r.splitAllTrumps, isTrue);
      expect(r.splitNoTrumps, isFalse);
      expect(r.splitSuit, isFalse);
      expect(r.continueOnTie, isTrue);
      expect(r.stepsOnTie, 50);
      expect(r.pointIfError, isTrue);
      expect(r.pointOnError, 10);
      expect(r.winIfCapotByDefense, isFalse);
      expect(r.redoubleNoTrumps, isFalse);
      expect(r.stake, isFalse);
      expect(r.stakeAmount, 0);
      expect(r.stakeDoubledOnCapot, isTrue);
    });

    test('copyWith updates only specified fields', () {
      const r = Rules();
      final r2 = r.copyWith(finalScore: 200, stake: true, stakeAmount: 500);
      expect(r2.finalScore, 200);
      expect(r2.stake, isTrue);
      expect(r2.stakeAmount, 500);
      expect(r2.splitAllTrumps, r.splitAllTrumps);
      expect(r2.continueOnTie, r.continueOnTie);
    });

    test('json roundtrip preserves values', () {
      const r = Rules();
      expect(Rules.fromJson(r.toJson()), equals(r));
    });
  });
}
