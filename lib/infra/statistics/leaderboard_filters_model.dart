class LeaderboardFilters {
  final int tournamentId;
  final String per;
  final int? limit;
  final String? order;
  final int? minGames;
  final int? teamId;

  const LeaderboardFilters({
    required this.tournamentId,
    required this.per,
    this.limit,
    this.order,
    this.minGames,
    this.teamId,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'tournament_id': tournamentId.toString(),
      'per': per,
    };

    if (limit != null) params['limit'] = limit.toString();
    if (order != null) params['order'] = order;
    if (minGames != null) params['min_games'] = minGames.toString();
    if (teamId != null) params['team_id'] = teamId.toString();

    return params;
  }

  LeaderboardFilters copyWith({
    int? tournamentId,
    String? per,
    int? limit,
    String? order,
    int? minGames,
    int? teamId,
  }) {
    return LeaderboardFilters(
      tournamentId: tournamentId ?? this.tournamentId,
      per: per ?? this.per,
      limit: limit ?? this.limit,
      order: order ?? this.order,
      minGames: minGames ?? this.minGames,
      teamId: teamId ?? this.teamId,
    );
  }

  @override
  String toString() {
    return 'LeaderboardFilters{tournamentId: $tournamentId, per: $per, limit: $limit, order: $order, minGames: $minGames, teamId: $teamId}';
  }
}
