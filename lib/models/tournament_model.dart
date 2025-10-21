
import 'league_model.dart';

class Tournament {
  final int id;
  final int leagueId;
  final String name;
  final DateTime startAt;
  final DateTime endAt;
  final int regulationDuration;
  final League? league;

  const Tournament({
    required this.id,
    required this.leagueId,
    required this.name,
    required this.startAt,
    required this.endAt,
    required this.regulationDuration,
    this.league,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as int,
      leagueId: json['league_id'] as int,
      name: json['name'] as String,
      startAt: DateTime.parse(json['start_at'] as String),
      endAt: DateTime.parse(json['end_at'] as String),
      regulationDuration: json['regulation_duration'] as int,
      league: json['league'] != null 
          ? League.fromJson(json['league'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'league_id': leagueId,
      'name': name,
      'start_at': startAt.toIso8601String(),
      'end_at': endAt.toIso8601String(),
      'regulation_duration': regulationDuration,
      if (league != null) 'league': league!.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tournament &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Tournament{id: $id, name: $name, leagueId: $leagueId}';
}
