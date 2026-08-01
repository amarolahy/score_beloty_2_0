import 'package:meta/meta.dart';

@immutable
class Rules {
  const Rules({
    this.finalScore = 150,
    this.splitAllTrumps = true,
    this.splitNoTrumps = false,
    this.splitColor = false,
    this.continueOnTie = true,
    this.stepsOnTie = 50,
    this.pointIfError = true,
    this.pointOnError = 10,
    this.winIfCapotInside = false,
    this.redoubleNoTrumps = false,
    this.atStake = false,
    this.bet = false,
    this.betAmount = 0,
    this.doubleAmountOnCapotScore = true,
  });

  final int finalScore;
  final bool splitAllTrumps;
  final bool splitNoTrumps;
  final bool splitColor;
  final bool continueOnTie;
  final int stepsOnTie;
  final bool pointIfError;
  final int pointOnError;
  final bool winIfCapotInside;
  final bool redoubleNoTrumps;
  final bool atStake;
  final bool bet;
  final int betAmount;
  final bool doubleAmountOnCapotScore;

  Rules copyWith({
    int? finalScore,
    bool? splitAllTrumps,
    bool? splitNoTrumps,
    bool? splitColor,
    bool? continueOnTie,
    int? stepsOnTie,
    bool? pointIfError,
    int? pointOnError,
    bool? winIfCapotInside,
    bool? redoubleNoTrumps,
    bool? atStake,
    bool? bet,
    int? betAmount,
    bool? doubleAmountOnCapotScore,
  }) {
    return Rules(
      finalScore: finalScore ?? this.finalScore,
      splitAllTrumps: splitAllTrumps ?? this.splitAllTrumps,
      splitNoTrumps: splitNoTrumps ?? this.splitNoTrumps,
      splitColor: splitColor ?? this.splitColor,
      continueOnTie: continueOnTie ?? this.continueOnTie,
      stepsOnTie: stepsOnTie ?? this.stepsOnTie,
      pointIfError: pointIfError ?? this.pointIfError,
      pointOnError: pointOnError ?? this.pointOnError,
      winIfCapotInside: winIfCapotInside ?? this.winIfCapotInside,
      redoubleNoTrumps: redoubleNoTrumps ?? this.redoubleNoTrumps,
      atStake: atStake ?? this.atStake,
      bet: bet ?? this.bet,
      betAmount: betAmount ?? this.betAmount,
      doubleAmountOnCapotScore:
          doubleAmountOnCapotScore ?? this.doubleAmountOnCapotScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'finalScore': finalScore,
        'splitAllTrumps': splitAllTrumps,
        'splitNoTrumps': splitNoTrumps,
        'splitColor': splitColor,
        'continueOnTie': continueOnTie,
        'stepsOnTie': stepsOnTie,
        'pointIfError': pointIfError,
        'pointOnError': pointOnError,
        'winIfCapotInside': winIfCapotInside,
        'redoubleNoTrumps': redoubleNoTrumps,
        'atStake': atStake,
        'bet': bet,
        'betAmount': betAmount,
        'doubleAmountOnCapotScore': doubleAmountOnCapotScore,
      };

  factory Rules.fromJson(Map<String, dynamic> json) => Rules(
        finalScore: json['finalScore'] as int? ?? 150,
        splitAllTrumps: json['splitAllTrumps'] as bool? ?? true,
        splitNoTrumps: json['splitNoTrumps'] as bool? ?? false,
        splitColor: json['splitColor'] as bool? ?? false,
        continueOnTie: json['continueOnTie'] as bool? ?? true,
        stepsOnTie: json['stepsOnTie'] as int? ?? 50,
        pointIfError: json['pointIfError'] as bool? ?? true,
        pointOnError: json['pointOnError'] as int? ?? 10,
        winIfCapotInside: json['winIfCapotInside'] as bool? ?? false,
        redoubleNoTrumps: json['redoubleNoTrumps'] as bool? ?? false,
        atStake: json['atStake'] as bool? ?? false,
        bet: json['bet'] as bool? ?? false,
        betAmount: json['betAmount'] as int? ?? 0,
        doubleAmountOnCapotScore:
            json['doubleAmountOnCapotScore'] as bool? ?? true,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rules &&
        other.finalScore == finalScore &&
        other.splitAllTrumps == splitAllTrumps &&
        other.splitNoTrumps == splitNoTrumps &&
        other.splitColor == splitColor &&
        other.continueOnTie == continueOnTie &&
        other.stepsOnTie == stepsOnTie &&
        other.pointIfError == pointIfError &&
        other.pointOnError == pointOnError &&
        other.winIfCapotInside == winIfCapotInside &&
        other.redoubleNoTrumps == redoubleNoTrumps &&
        other.atStake == atStake &&
        other.bet == bet &&
        other.betAmount == betAmount &&
        other.doubleAmountOnCapotScore == doubleAmountOnCapotScore;
  }

  @override
  int get hashCode => Object.hash(
        finalScore,
        splitAllTrumps,
        splitNoTrumps,
        splitColor,
        continueOnTie,
        stepsOnTie,
        pointIfError,
        pointOnError,
        winIfCapotInside,
        redoubleNoTrumps,
        atStake,
        bet,
        betAmount,
        doubleAmountOnCapotScore,
      );
}
