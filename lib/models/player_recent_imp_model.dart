class PlayerRecentImp {
  final int playerId;
  final List<GameImp> games;
  final PlayerRecentImpMeta meta;

  const PlayerRecentImp({
    required this.playerId,
    required this.games,
    required this.meta,
  });

  factory PlayerRecentImp.fromJson(Map<String, dynamic> json) {
    return PlayerRecentImp(
      playerId: json['player_id'] as int,
      games:
          (json['games'] as List<dynamic>? ?? [])
              .map((item) => GameImp.fromJson(item as Map<String, dynamic>))
              .toList(),
      meta: PlayerRecentImpMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

class PlayerRecentImpMeta {
  final int total;
  final int offset;
  final int limit;

  const PlayerRecentImpMeta({
    required this.total,
    required this.offset,
    required this.limit,
  });

  factory PlayerRecentImpMeta.fromJson(Map<String, dynamic> json) {
    return PlayerRecentImpMeta(
      total: json['total'] as int? ?? 0,
      offset: json['offset'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}

class GameImp {
  final int gameId;
  final DateTime? scheduledAt;
  final double? imp;

  const GameImp({
    required this.gameId,
    required this.scheduledAt,
    required this.imp,
  });

  factory GameImp.fromJson(Map<String, dynamic> json) {
    final rawScheduledAt = json['scheduled_at'] as String?;
    return GameImp(
      gameId: json['game_id'] as int,
      scheduledAt: _parseScheduledAt(rawScheduledAt),
      imp: (json['imp'] as num?)?.toDouble(),
    );
  }

  static DateTime? _parseScheduledAt(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) return parsed;
    return DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  }
}
