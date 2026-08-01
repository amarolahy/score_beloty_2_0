import 'package:meta/meta.dart';

@immutable
class Rules {
  const Rules({
    this.finalScore = 150,
    this.splitAllTrumps = true,
    this.splitNoTrumps = false,
    this.splitSuit = false,
    this.continueOnTie = true,
    this.stepsOnTie = 50,
    this.pointIfError = true,
    this.pointOnError = 10,
    this.winIfCapotByDefense = false,
    this.redoubleNoTrumps = false,
    this.stake = false,
    this.stakeAmount = 0,
    this.stakeDoubledOnCapot = true,
  });

  /// Score a team needs to reach for the game to end.
  final int finalScore;

  /// Whether teams may split the trick points equally instead of declaring
  /// a winner for the contract.
  final bool splitAllTrumps;
  final bool splitNoTrumps;
  final bool splitSuit;

  /// "Miara miakatra" — when both teams are tied, raise the target score.
  final bool continueOnTie;

  /// Increment added to the target score after a tie (when [continueOnTie] is
  /// enabled).
  final int stepsOnTie;

  /// Whether a team receives bonus points when a player makes an "error"
  /// during the deal (fausse annonce, played out of turn, etc.).
  final bool pointIfError;

  /// Bonus points awarded on an "error" when [pointIfError] is enabled.
  final int pointOnError;

  /// When true, a "capot scored by the defense" (capot par la défense, formerly
  /// called "capot dedans") immediately wins the game.
  final bool winIfCapotByDefense;

  /// Whether a team may "redouble" (surcontrer) when the contract is "no trumps".
  final bool redoubleNoTrumps;

  /// Whether a side stake is enabled for the game.
  final bool stake;

  /// Amount of the side stake (in Ariary).
  final int stakeAmount;

  /// Whether the stake amount is doubled when a capot is scored.
  final bool stakeDoubledOnCapot;

  Rules copyWith({
    int? finalScore,
    bool? splitAllTrumps,
    bool? splitNoTrumps,
    bool? splitSuit,
    bool? continueOnTie,
    int? stepsOnTie,
    bool? pointIfError,
    int? pointOnError,
    bool? winIfCapotByDefense,
    bool? redoubleNoTrumps,
    bool? stake,
    int? stakeAmount,
    bool? stakeDoubledOnCapot,
  }) {
    return Rules(
      finalScore: finalScore ?? this.finalScore,
      splitAllTrumps: splitAllTrumps ?? this.splitAllTrumps,
      splitNoTrumps: splitNoTrumps ?? this.splitNoTrumps,
      splitSuit: splitSuit ?? this.splitSuit,
      continueOnTie: continueOnTie ?? this.continueOnTie,
      stepsOnTie: stepsOnTie ?? this.stepsOnTie,
      pointIfError: pointIfError ?? this.pointIfError,
      pointOnError: pointOnError ?? this.pointOnError,
      winIfCapotByDefense: winIfCapotByDefense ?? this.winIfCapotByDefense,
      redoubleNoTrumps: redoubleNoTrumps ?? this.redoubleNoTrumps,
      stake: stake ?? this.stake,
      stakeAmount: stakeAmount ?? this.stakeAmount,
      stakeDoubledOnCapot: stakeDoubledOnCapot ?? this.stakeDoubledOnCapot,
    );
  }

  Map<String, dynamic> toJson() => {
        'finalScore': finalScore,
        'splitAllTrumps': splitAllTrumps,
        'splitNoTrumps': splitNoTrumps,
        'splitSuit': splitSuit,
        'continueOnTie': continueOnTie,
        'stepsOnTie': stepsOnTie,
        'pointIfError': pointIfError,
        'pointOnError': pointOnError,
        'winIfCapotByDefense': winIfCapotByDefense,
        'redoubleNoTrumps': redoubleNoTrumps,
        'stake': stake,
        'stakeAmount': stakeAmount,
        'stakeDoubledOnCapot': stakeDoubledOnCapot,
      };

  factory Rules.fromJson(Map<String, dynamic> json) => Rules(
        finalScore: json['finalScore'] as int? ?? 150,
        splitAllTrumps: json['splitAllTrumps'] as bool? ?? true,
        splitNoTrumps: json['splitNoTrumps'] as bool? ?? false,
        splitSuit: json['splitSuit'] as bool? ?? false,
        continueOnTie: json['continueOnTie'] as bool? ?? true,
        stepsOnTie: json['stepsOnTie'] as int? ?? 50,
        pointIfError: json['pointIfError'] as bool? ?? true,
        pointOnError: json['pointOnError'] as int? ?? 10,
        winIfCapotByDefense: json['winIfCapotByDefense'] as bool? ?? false,
        redoubleNoTrumps: json['redoubleNoTrumps'] as bool? ?? false,
        stake: json['stake'] as bool? ?? false,
        stakeAmount: json['stakeAmount'] as int? ?? 0,
        stakeDoubledOnCapot: json['stakeDoubledOnCapot'] as bool? ?? true,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rules &&
        other.finalScore == finalScore &&
        other.splitAllTrumps == splitAllTrumps &&
        other.splitNoTrumps == splitNoTrumps &&
        other.splitSuit == splitSuit &&
        other.continueOnTie == continueOnTie &&
        other.stepsOnTie == stepsOnTie &&
        other.pointIfError == pointIfError &&
        other.pointOnError == pointOnError &&
        other.winIfCapotByDefense == winIfCapotByDefense &&
        other.redoubleNoTrumps == redoubleNoTrumps &&
        other.stake == stake &&
        other.stakeAmount == stakeAmount &&
        other.stakeDoubledOnCapot == stakeDoubledOnCapot;
  }

  @override
  int get hashCode => Object.hash(
        finalScore,
        splitAllTrumps,
        splitNoTrumps,
        splitSuit,
        continueOnTie,
        stepsOnTie,
        pointIfError,
        pointOnError,
        winIfCapotByDefense,
        redoubleNoTrumps,
        stake,
        stakeAmount,
        stakeDoubledOnCapot,
      );
}
