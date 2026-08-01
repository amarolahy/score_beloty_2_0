import 'package:meta/meta.dart';

import 'deal.dart';
import 'rules.dart';
import 'team.dart';

enum GameState { begin, running, finished }

enum Winner { us, them, none }

@immutable
class Game {
  const Game({
    required this.us,
    required this.them,
    required this.rules,
    this.deals = const <Deal>[],
    this.state = GameState.begin,
    required this.createdOn,
    this.effectiveFinalScore,
  });

  final Team us;
  final Team them;
  final Rules rules;
  final List<Deal> deals;
  final GameState state;
  final DateTime createdOn;
  final int? effectiveFinalScore;

  factory Game.fresh({
    required Team us,
    required Team them,
    required Rules rules,
    List<Deal> deals = const <Deal>[],
    GameState state = GameState.begin,
    DateTime? createdOn,
    int? effectiveFinalScore,
  }) {
    return Game(
      us: us,
      them: them,
      rules: rules,
      deals: deals,
      state: state,
      createdOn: createdOn ?? DateTime.now(),
      effectiveFinalScore: effectiveFinalScore,
    );
  }

  int get _threshold => effectiveFinalScore ?? rules.finalScore;

  Deal? get currentDeal => deals.isEmpty ? null : deals.last;

  Deal? get lastFinishedDeal {
    for (var i = deals.length - 1; i >= 0; i--) {
      if (deals[i].result != null) return deals[i];
    }
    return null;
  }

  int get effectiveFinalScoreValue => _threshold;

  int get ourScore {
    return us.initialScore +
        deals
            .where((d) => d.result != null)
            .fold<int>(0, (acc, d) => acc + d.ourPoints);
  }

  int get theirScore {
    return them.initialScore +
        deals
            .where((d) => d.result != null)
            .fold<int>(0, (acc, d) => acc + d.theirPoints);
  }

  bool get isOver => ourScore >= _threshold || theirScore >= _threshold;

  Winner get winner {
    if (!isOver) return Winner.none;
    return ourScore >= _threshold ? Winner.us : Winner.them;
  }

  Game addDeal(Deal deal) => copyWith(
        deals: [...deals, deal],
        state: GameState.running,
      );

  Game? removeLastDeal() {
    if (deals.isEmpty) return null;
    final remaining = deals.sublist(0, deals.length - 1);
    return copyWith(
      deals: remaining,
      state: remaining.isEmpty ? GameState.begin : state,
      resetEffectiveFinalScore: true,
    );
  }

  Game continueCauseTie({int? ourScoreOverride, int? theirScoreOverride}) {
    if (!rules.continueOnTie) return this;
    final o = ourScoreOverride ?? ourScore;
    final t = theirScoreOverride ?? theirScore;
    if (o != t) return this;
    return copyWith(effectiveFinalScore: _threshold + rules.stepsOnTie);
  }

  Game markFinishedIfNeeded() {
    if (isOver && state != GameState.finished) {
      return copyWith(state: GameState.finished);
    }
    return this;
  }

  Game copyWith({
    Team? us,
    Team? them,
    Rules? rules,
    List<Deal>? deals,
    GameState? state,
    DateTime? createdOn,
    int? effectiveFinalScore,
    bool resetEffectiveFinalScore = false,
  }) {
    return Game(
      us: us ?? this.us,
      them: them ?? this.them,
      rules: rules ?? this.rules,
      deals: deals ?? this.deals,
      state: state ?? this.state,
      createdOn: createdOn ?? this.createdOn,
      effectiveFinalScore: resetEffectiveFinalScore
          ? null
          : (effectiveFinalScore ?? this.effectiveFinalScore),
    );
  }

  Map<String, dynamic> toJson() => {
        'us': us.toJson(),
        'them': them.toJson(),
        'rules': rules.toJson(),
        'deals': deals.map((d) => d.toJson()).toList(),
        'state': state.name,
        'createdOn': createdOn.toIso8601String(),
        'effectiveFinalScore': effectiveFinalScore,
      };

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        us: Team.fromJson(json['us'] as Map<String, dynamic>),
        them: Team.fromJson(json['them'] as Map<String, dynamic>),
        rules: Rules.fromJson(json['rules'] as Map<String, dynamic>),
        deals: (json['deals'] as List<dynamic>)
            .map((e) => Deal.fromJson(e as Map<String, dynamic>))
            .toList(),
        state: GameState.values
            .byName(json['state'] as String? ?? GameState.begin.name),
        createdOn: DateTime.parse(json['createdOn'] as String),
        effectiveFinalScore: json['effectiveFinalScore'] as int?,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Game &&
        other.us == us &&
        other.them == them &&
        other.rules == rules &&
        other.state == state &&
        other.createdOn == createdOn &&
        other.effectiveFinalScore == effectiveFinalScore &&
        _dealsEquals(other.deals, deals);
  }

  static bool _dealsEquals(List<Deal> a, List<Deal> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        us,
        them,
        rules,
        state,
        createdOn,
        effectiveFinalScore,
        Object.hashAll(deals),
      );
}
