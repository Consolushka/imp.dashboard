
import 'player_model.dart';

class GameTeamPlayerStat {
  final int id;
  final int gameId;
  final int teamId;
  final int playerId;
  final int playedSeconds;
  final int plusMinus;
  final Player? player;

  const GameTeamPlayerStat({
    required this.id,
    required this.gameId,
    required this.teamId,
    required this.playerId,
    required this.playedSeconds,
    required this.plusMinus,
    this.player,
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
