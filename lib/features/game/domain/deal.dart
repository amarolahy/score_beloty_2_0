import 'package:meta/meta.dart';

enum ContractType {
  allTrumps,
  noTrumps,
  spades,
  hearts,
  diamonds,
  clubs,

  /// Deal ended because a player made an "error" (fausse annonce, played out
  /// of turn, etc.); 16 points are awarded directly to the opposing team.
  error,
}

enum BidType { pass, double_, redouble }

enum ResultType { weWin, theyWin, split, dispute }

enum CapotType { no, capot, capotByDefense }

@immutable
class Deal {
  const Deal({
    required this.contract,
    required this.bid,
    required this.beginAt,
    this.capot = CapotType.no,
    this.result,
    this.ourPoints = 0,
    this.theirPoints = 0,
    this.tie = false,
  });

  final ContractType contract;
  final BidType bid;
  final DateTime beginAt;
  final CapotType capot;
  final ResultType? result;
  final int ourPoints;
  final int theirPoints;
  final bool tie;

  bool get isFinished => result != null;

  Deal copyWith({
    ContractType? contract,
    BidType? bid,
    DateTime? beginAt,
    CapotType? capot,
    ResultType? result,
    bool clearResult = false,
    int? ourPoints,
    int? theirPoints,
    bool? tie,
  }) {
    return Deal(
      contract: contract ?? this.contract,
      bid: bid ?? this.bid,
      beginAt: beginAt ?? this.beginAt,
      capot: capot ?? this.capot,
      result: clearResult ? null : (result ?? this.result),
      ourPoints: ourPoints ?? this.ourPoints,
      theirPoints: theirPoints ?? this.theirPoints,
      tie: tie ?? this.tie,
    );
  }

  Map<String, dynamic> toJson() => {
        'contract': contract.name,
        'bid': bid.name,
        'beginAt': beginAt.toIso8601String(),
        'capot': capot.name,
        'result': result?.name,
        'ourPoints': ourPoints,
        'theirPoints': theirPoints,
        'tie': tie,
      };

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
        contract: ContractType.values.byName(json['contract'] as String),
        bid: BidType.values.byName(json['bid'] as String),
        beginAt: DateTime.parse(json['beginAt'] as String),
        capot: CapotType.values
            .byName(json['capot'] as String? ?? CapotType.no.name),
        result: json['result'] == null
            ? null
            : ResultType.values.byName(json['result'] as String),
        ourPoints: json['ourPoints'] as int? ?? 0,
        theirPoints: json['theirPoints'] as int? ?? 0,
        tie: json['tie'] as bool? ?? false,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Deal &&
        other.contract == contract &&
        other.bid == bid &&
        other.beginAt == beginAt &&
        other.capot == capot &&
        other.result == result &&
        other.ourPoints == ourPoints &&
        other.theirPoints == theirPoints &&
        other.tie == tie;
  }

  @override
  int get hashCode => Object.hash(
        contract,
        bid,
        beginAt,
        capot,
        result,
        ourPoints,
        theirPoints,
        tie,
      );
}
