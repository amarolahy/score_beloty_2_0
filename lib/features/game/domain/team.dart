import 'package:meta/meta.dart';

@immutable
class Team {
  const Team({
    required this.player1,
    required this.player2,
    this.initialScore = 0,
  });

  final String player1;
  final String player2;
  final int initialScore;

  Team copyWith({String? player1, String? player2, int? initialScore}) {
    return Team(
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      initialScore: initialScore ?? this.initialScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'player1': player1,
        'player2': player2,
        'initialScore': initialScore,
      };

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        player1: json['player1'] as String,
        player2: json['player2'] as String,
        initialScore: json['initialScore'] as int? ?? 0,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Team &&
        other.player1 == player1 &&
        other.player2 == player2 &&
        other.initialScore == initialScore;
  }

  @override
  int get hashCode => Object.hash(player1, player2, initialScore);
}
