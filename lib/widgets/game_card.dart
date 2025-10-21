import 'package:flutter/material.dart';
import '../models/game_model.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback? onTap;
  final bool showTournament;

  const GameCard({
    super.key,
    required this.game,
    this.onTap,
    this.showTournament = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с турниром (если нужно)
              if (showTournament && game.tournament != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${game.tournament!.league?.name ?? ''} • ${game.tournament!.name}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Основная информация об игре
              Row(
                children: [
                  // Дата и время
                  SizedBox(
                    width: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatTime(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(width: 16),

                  // Команды и счет
                  Expanded(
                    child: _buildGameInfo(context),
                  ),

                  const SizedBox(width: 20,),

                  // Статус и стрелка
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    // Игра с результатом
    final team1 = game.teamStats![0];
    final team2 = game.teamStats![1];
    final winner = team1.isWinner ? team1 : team2;
    final loser = team1.isWinner ? team2 : team1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Команда-победитель
        _buildTeamRow(context, winner, isWinner: true),
        const SizedBox(height: 8),
        // Команда-проигравший
        _buildTeamRow(context, loser, isWinner: false),
      ],
    );
  }

  Widget _buildTeamRow(BuildContext context, dynamic teamStat, {required bool isWinner}) {
    return Row(
      children: [
        // Место для логотипа команды (пока заглушка)
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            border: Border.all(
              color: isWinner ? Colors.black : Colors.grey,
              width: isWinner ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.sports_basketball,
            size: 16,
            color: isWinner ? Colors.black : Colors.grey,
          ),
        ),
        const SizedBox(width: 12),

        // Название команды
        Expanded(
          child: Text(
            teamStat.team?.name ?? 'Команда ${teamStat.teamId}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: isWinner ? FontWeight.w600 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 12),

        // Счет команды
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isWinner ? Colors.black : Colors.transparent,
            border: isWinner ? null : Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${teamStat.score}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isWinner ? Colors.white : Colors.grey[600],
              fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate() {
    return '${game.scheduledAt.day.toString().padLeft(2, '0')}.${game.scheduledAt.month.toString().padLeft(2, '0')}';
  }

  String _formatTime() {
    return '${game.scheduledAt.hour.toString().padLeft(2, '0')}:${game.scheduledAt.minute.toString().padLeft(2, '0')}';
  }
}
