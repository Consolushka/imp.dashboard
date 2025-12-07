
import 'player_model.dart';

class RankedPlayer {
  final int position;
  final Player player;
  final int gamesCount;
  final double avgImp;

  const RankedPlayer({
    required this.position,
    required this.player,
    required this.gamesCount,
    required this.avgImp,
  });

  factory RankedPlayer.fromJson(Map<String, dynamic> json) {
    return RankedPlayer(
      position: json['position'] as int,
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      gamesCount: json['games_count'] as int,
      avgImp: (json['avg_imp'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'player': player.toJson(),
      'games_count': gamesCount,
      'avg_imp': avgImp,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankedPlayer &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          player == other.player;

  @override
  int get hashCode => Object.hash(position, player);

  @override
  String toString() => 'RankedPlayer{position: $position, player: ${player.fullName}, gamesCount: $gamesCount, avgImp: $avgImp}';
}
