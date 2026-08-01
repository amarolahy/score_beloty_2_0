import 'deal.dart';
import 'rules.dart';

class ScoringEngine {
  ScoringEngine._();

  /// Trick points the defender earns when the bidder fails the contract.
  /// Indexed by [ContractType] minus 1 (see the order in [ContractType]).
  static const List<int> _trickPoints = [26, 52, 16, 16, 16, 32];

  /// Total points when the bidder scores a capot.
  static const List<int> _capotPoints = [35, 90, 162, 162, 162, 162];

  /// Total points when the defense scores a capot (formerly "capot dedans").
  static const List<int> _capotByDefensePoints = [45, 120, 162, 162, 162, 162];

  static int trickPoints(ContractType contract) {
    if (contract == ContractType.error) return 0;
    return _trickPoints[contract.index];
  }

  static int capotPoints(ContractType contract, Rules rules) {
    if (contract == ContractType.error) return 0;
    return _resolve(_capotPoints[contract.index], rules.finalScore);
  }

  static int capotByDefensePoints(ContractType contract, Rules rules) {
    if (contract == ContractType.error) return 0;
    if (rules.winIfCapotByDefense) return rules.finalScore;
    return _resolve(_capotByDefensePoints[contract.index], rules.finalScore);
  }

  static int bidMultiplier(BidType bid, ContractType contract, Rules rules) {
    if (bid == BidType.pass) return 1;
    if (contract == ContractType.noTrumps && !rules.redoubleNoTrumps) {
      return 1;
    }
    switch (bid) {
      case BidType.pass:
        return 1;
      case BidType.double_:
        return 2;
      case BidType.redouble:
        return 4;
    }
  }

  static int basePoints({
    required ContractType contract,
    required CapotType capot,
    required Rules rules,
  }) {
    switch (capot) {
      case CapotType.no:
        return trickPoints(contract);
      case CapotType.capot:
        return capotPoints(contract, rules);
      case CapotType.capotByDefense:
        return capotByDefensePoints(contract, rules);
    }
  }

  static int computeTotal({
    required ContractType contract,
    required BidType bid,
    required CapotType capot,
    required Rules rules,
  }) {
    return basePoints(contract: contract, capot: capot, rules: rules) *
        bidMultiplier(bid, contract, rules);
  }

  static bool isSplitAllowed(ContractType contract, Rules rules) {
    switch (contract) {
      case ContractType.allTrumps:
        return rules.splitAllTrumps;
      case ContractType.noTrumps:
        return rules.splitNoTrumps;
      case ContractType.error:
        return false;
      default:
        return rules.splitSuit;
    }
  }

  static int _resolve(int base, int finalScore) {
    return base == 162 ? finalScore : base;
  }
}

class DealOutcome {
  const DealOutcome({
    required this.result,
    required this.ourPoints,
    required this.theirPoints,
    required this.tie,
  });

  final ResultType result;
  final int ourPoints;
  final int theirPoints;
  final bool tie;

  factory DealOutcome.usWin(int points) => DealOutcome(
        result: ResultType.weWin,
        ourPoints: points,
        theirPoints: 0,
        tie: false,
      );

  factory DealOutcome.themWin(int points) => DealOutcome(
        result: ResultType.theyWin,
        ourPoints: 0,
        theirPoints: points,
        tie: false,
      );

  factory DealOutcome.split(int ours, int theirs) => DealOutcome(
        result: ResultType.split,
        ourPoints: ours,
        theirPoints: theirs,
        tie: false,
      );

  /// Outcome when both sides disagree on the deal's score ("litige" in
  /// French). The current total for each side is preserved; a same value
  /// on both sides flags the deal as a tie.
  factory DealOutcome.dispute(int ours, int theirs) => DealOutcome(
        result: ResultType.dispute,
        ourPoints: ours,
        theirPoints: theirs,
        tie: ours == theirs,
      );

  Deal toDeal({
    required DateTime beginAt,
    required ContractType contract,
    required BidType bid,
    CapotType capot = CapotType.no,
  }) {
    return Deal(
      contract: contract,
      bid: bid,
      beginAt: beginAt,
      capot: capot,
      result: result,
      ourPoints: ourPoints,
      theirPoints: theirPoints,
      tie: tie,
    );
  }
}
