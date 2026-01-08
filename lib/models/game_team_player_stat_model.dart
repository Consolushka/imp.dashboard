
import 'player_model.dart';

class GameTeamPlayerStat {
  final int id;
  final int gameId;
  final int teamId;
  final int playerId;
  final int playedSeconds;
  final int plusMinus;
  final Player? player;
  final int points;
  final int assists;
  final int rebounds;
  final int steals;
  final int blocks;
  final double fieldGoalsPercentage;
  final int turnovers;

  const GameTeamPlayerStat({
    required this.id,
    required this.gameId,
    required this.teamId,
    required this.playerId,
    required this.playedSeconds,
    required this.plusMinus,
    this.player,
    required this.points,
    required this.assists,
    required this.rebounds,
    required this.steals,
    required this.blocks,
    required this.fieldGoalsPercentage,
    required this.turnovers,
  });

  factory GameTeamPlayerStat.fromJson(Map<String, dynamic> json) {
    return GameTeamPlayerStat(
      id: json['id'] as int,
      gameId: json['game_id'] as int,
      teamId: json['team_id'] as int,
      playerId: json['player_id'] as int,
      playedSeconds: json['played_seconds'] as int,
      plusMinus: json['plus_minus'] as int,
      player: json['player'] != null
          ? Player.fromJson(json['player'] as Map<String, dynamic>)
          : null,
      points: json['points'] as int,
      assists: json['assists'] as int,
      rebounds: json['rebounds'] as int,
      steals: json['steals'] as int,
      blocks: json['blocks'] as int,
      fieldGoalsPercentage: double.parse(json['field_goals_percentage'].toString()),
      turnovers: json['turnovers'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'team_id': teamId,
      'player_id': playerId,
      'played_seconds': playedSeconds,
      'plus_minus': plusMinus,
      if (player != null) 'player': player!.toJson(),
      'points': points,
      'assists': assists,
      'rebounds': rebounds,
      'steals': steals,
      'blocks': blocks,
      'field_goals_percentage': fieldGoalsPercentage,
      'turnovers': turnovers,
    };
  }

  String get playedTime {
    final minutes = playedSeconds ~/ 60;
    final seconds = playedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameTeamPlayerStat &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'GameTeamPlayerStat{playerId: $playerId, playedTime: $playedTime, +/-: $plusMinus}';
}
