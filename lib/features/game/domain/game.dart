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
    this.raisedTarget,
  });

  final Team us;
  final Team them;
  final Rules rules;
  final List<Deal> deals;
  final GameState state;
  final DateTime createdOn;

  /// Optional raised target score after a tie (miara miakatra).
  /// When set, this value replaces [Rules.finalScore] until the game ends.
  final int? raisedTarget;

  factory Game.fresh({
    required Team us,
    required Team them,
    required Rules rules,
    List<Deal> deals = const <Deal>[],
    GameState state = GameState.begin,
    DateTime? createdOn,
    int? raisedTarget,
  }) {
    return Game(
      us: us,
      them: them,
      rules: rules,
      deals: deals,
      state: state,
      createdOn: createdOn ?? DateTime.now(),
      raisedTarget: raisedTarget,
    );
  }

  int get _currentTarget => raisedTarget ?? rules.finalScore;

  Deal? get currentDeal => deals.isEmpty ? null : deals.last;

  Deal? get lastFinishedDeal {
    for (var i = deals.length - 1; i >= 0; i--) {
      if (deals[i].result != null) return deals[i];
    }
    return null;
  }

  int get targetScore => _currentTarget;

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

  bool get isOver => ourScore >= _currentTarget || theirScore >= _currentTarget;

  Winner get winner {
    if (!isOver) return Winner.none;
    return ourScore >= _currentTarget ? Winner.us : Winner.them;
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
      resetRaisedTarget: true,
    );
  }

  Game continueAfterTie({int? ourScoreOverride, int? theirScoreOverride}) {
    if (!rules.continueOnTie) return this;
    final o = ourScoreOverride ?? ourScore;
    final t = theirScoreOverride ?? theirScore;
    if (o != t) return this;
    return copyWith(raisedTarget: _currentTarget + rules.stepsOnTie);
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
    int? raisedTarget,
    bool resetRaisedTarget = false,
  }) {
    return Game(
      us: us ?? this.us,
      them: them ?? this.them,
      rules: rules ?? this.rules,
      deals: deals ?? this.deals,
      state: state ?? this.state,
      createdOn: createdOn ?? this.createdOn,
      raisedTarget: resetRaisedTarget
          ? null
          : (raisedTarget ?? this.raisedTarget),
    );
  }

  Map<String, dynamic> toJson() => {
        'us': us.toJson(),
        'them': them.toJson(),
        'rules': rules.toJson(),
        'deals': deals.map((d) => d.toJson()).toList(),
        'state': state.name,
        'createdOn': createdOn.toIso8601String(),
        'raisedTarget': raisedTarget,
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
        raisedTarget: json['raisedTarget'] as int?,
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
        other.raisedTarget == raisedTarget &&
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
        raisedTarget,
        Object.hashAll(deals),
      );
}
