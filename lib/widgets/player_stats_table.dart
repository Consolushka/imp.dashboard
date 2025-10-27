import 'package:flutter/material.dart';
import '../models/game_team_player_stat_model.dart';
import '../models/pers.dart';
import '../models/player_stat_imp_model.dart';

class PlayerStatsTable extends StatelessWidget {
  final String teamName;
  final int teamScore;
  final bool isWinner;
  final List<GameTeamPlayerStat> playerStats;
  final Map<int, List<PlayerStatImp>> playerImps;
  final List<ImpPer> pers;

  const PlayerStatsTable({
    super.key,
    required this.teamName,
    required this.teamScore,
    required this.isWinner,
    required this.playerStats,
    required this.playerImps,
    required this.pers,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок команды
            _buildTeamHeader(context),
            const SizedBox(height: 16),

            // Заголовки столбцов
            _buildTableHeader(context),
            const SizedBox(height: 8),

            // Строки игроков
            ...playerStats.map((stat) => _buildPlayerRow(context, stat)),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader(BuildContext context) {
    return Row(
      children: [
        // Логотип команды
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: isWinner ? Colors.black : Colors.grey, width: isWinner ? 2 : 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.sports_basketball, size: 20, color: isWinner ? Colors.black : Colors.grey),
        ),
        const SizedBox(width: 12),

        // Название и счет команды
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teamName,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: isWinner ? FontWeight.bold : FontWeight.w500),
              ),
              Text(
                'Счет: $teamScore',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Статус команды
        if (isWinner) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
            child: Text(
              'ПОБЕДА',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 10),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Аватарка
          const SizedBox(width: 40),
          const SizedBox(width: 12),

          // Игрок
          Expanded(
            flex: 3,
            child: Text(
              'Игрок',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
          ),

          // Время
          SizedBox(
            width: 60,
            child: Text(
              'Время',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(width: 8),

          // +/-
          SizedBox(
            width: 50,
            child: Text(
              '+/–',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(width: 8),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "IMP",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              ),
              SizedBox(height: 16,),
              Row(
                children: [
                  for (var i = 0; i < pers.length; i++)
                    ...[
                      SizedBox(
                        width: 100,
                        child: Text(
                          pers[i].toString(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 8,),
                    ]
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(BuildContext context, GameTeamPlayerStat stat) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
      child: Row(
        children: [
          // Аватарка игрока
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[50],
            ),
            child: const Icon(Icons.person, size: 20, color: Colors.grey),
          ),

          const SizedBox(width: 12),

          // Имя игрока
          Expanded(
            flex: 3,
            child: Text(
              stat.player?.fullName ?? 'Игрок ${stat.playerId}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Время игры
          SizedBox(
            width: 60,
            child: Text(
              _formatPlayTime(stat.playedSeconds),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(width: 8),

          // +/-
          SizedBox(
            width: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: _getPlusMinusColor(stat.plusMinus),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                stat.plusMinus > 0 ? '+${stat.plusMinus}' : '${stat.plusMinus}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(width: 8),
          for (var i = 0; i < pers.length; i++) ..._getPlayerImpPerSizedBox(context, stat.id, pers[i]),
        ],
      ),
    );
  }

  List<Widget> _getPlayerImpPerSizedBox(BuildContext context, int playerStatId, ImpPer per) {
    final imp = _getBenchImp(playerStatId, per);

    return [
      SizedBox(
        width: 100,
        child:
            imp != null
                ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(color: _getImpColor(imp.imp), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    imp.imp > 0 ? '+${imp.imp.toStringAsFixed(1)}' : imp.imp.toStringAsFixed(1),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
                : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '—',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
      ),
      const SizedBox(width: 8),
    ];
  }

  // Получаем IMP для "bench" периода
  PlayerStatImp? _getBenchImp(int playerStatId, ImpPer per) {
    final imps = playerImps[playerStatId];
    if (imps == null) return null;

    try {
      return imps.firstWhere((imp) => imp.per == per.code);
    } catch (e) {
      return null;
    }
  }

  String _formatPlayTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getPlusMinusColor(int plusMinus) {
    if (plusMinus > 0) {
      return Colors.green;
    } else if (plusMinus < 0) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Color _getImpColor(double imp) {
    if (imp >= 15) {
      return Colors.green[800]!;
    } else if (imp >= 10) {
      return Colors.green[600]!;
    } else if (imp >= 5) {
      return Colors.green[400]!;
    } else if (imp >= 0) {
      return Colors.grey[600]!;
    } else if (imp >= -5) {
      return Colors.orange[400]!;
    } else if (imp >= -10) {
      return Colors.red[400]!;
    } else {
      return Colors.red[800]!;
    }
  }
}
