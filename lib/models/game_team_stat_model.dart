import 'game_team_player_stat_model.dart';
import 'team_model.dart';

class GameTeamStat {
  final int id;
  final int gameId;
  final int teamId;
  final int score;
  final int finalDiff;
  final Team? team;
  final List<GameTeamPlayerStat>? playerStats;

  const GameTeamStat({
    required this.id,
    required this.gameId,
    required this.teamId,
    required this.score,
    required this.finalDiff,
    this.team,
    this.playerStats,
  });

  factory GameTeamStat.fromJson(Map<String, dynamic> json) {
    return GameTeamStat(
      id: json['id'] as int,
      gameId: json['game_id'] as int,
      teamId: json['team_id'] as int,
      score: json['score'] as int,
      finalDiff: json['final_differential'] as int,
      team: json['team'] != null
          ? Team.fromJson(json['team'] as Map<String, dynamic>)
          : null,
      playerStats: json['playerStats'] != null
          ? (json['playerStats'] as List)
              .map((stat) => GameTeamPlayerStat.fromJson(stat as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'team_id': teamId,
      'score': score,
      'final_differential': finalDiff,
      if (team != null) 'team': team!.toJson(),
      if (playerStats != null)
        'playerStats': playerStats!.map((stat) => stat.toJson()).toList(),
    };
  }

  bool get isWinner => finalDiff > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameTeamStat &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'GameTeamStat{teamId: $teamId, score: $score, diff: $finalDiff}';
}
