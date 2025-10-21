import 'tournament_model.dart';
import 'game_team_stat_model.dart';

class Game {
  final int id;
  final int tournamentId;
  final DateTime scheduledAt;
  final String title;
  final Tournament? tournament;
  final List<GameTeamStat>? teamStats;

  const Game({
    required this.id,
    required this.tournamentId,
    required this.scheduledAt,
    required this.title,
    this.tournament,
    this.teamStats,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int,
      tournamentId: json['tournament_id'] as int,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      title: json['title'] as String,
      tournament: json['tournament'] != null
          ? Tournament.fromJson(json['tournament'] as Map<String, dynamic>)
          : null,
      teamStats: json['game_team_stats'] != null
          ? (json['game_team_stats'] as List)
              .map((stat) => GameTeamStat.fromJson(stat as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournament_id': tournamentId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'title': title,
      if (tournament != null) 'tournament': tournament!.toJson(),
      if (teamStats != null)
        'team_stats': teamStats!.map((stat) => stat.toJson()).toList(),
    };
  }

  bool get isFinished => teamStats != null && teamStats!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Game &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Game{id: $id, title: $title, scheduledAt: $scheduledAt}';
}
