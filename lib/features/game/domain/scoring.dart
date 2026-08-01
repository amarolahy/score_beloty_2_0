import 'deal.dart';
import 'rules.dart';

class ScoringEngine {
  ScoringEngine._();

  static const List<int> _dedansBase = [26, 52, 16, 16, 16, 32];
  static const List<int> _capotBase = [35, 90, 162, 162, 162, 162];
  static const List<int> _capotInsideBase = [45, 120, 162, 162, 162, 162];

  static int dedansPoints(ContractType contract) {
    if (contract == ContractType.error) return 0;
    return _dedansBase[contract.index];
  }

  static int capotPoints(ContractType contract, Rules rules) {
    if (contract == ContractType.error) return 0;
    return _resolve(_capotBase[contract.index], rules.finalScore);
  }

  static int capotInsidePoints(ContractType contract, Rules rules) {
    if (contract == ContractType.error) return 0;
    if (rules.winIfCapotInside) return rules.finalScore;
    return _resolve(_capotInsideBase[contract.index], rules.finalScore);
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
        return dedansPoints(contract);
      case CapotType.capot:
        return capotPoints(contract, rules);
      case CapotType.capotInside:
        return capotInsidePoints(contract, rules);
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
        return rules.splitColor;
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

  factory DealOutcome.litigation(int ours, int theirs) => DealOutcome(
        result: ResultType.litigation,
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
