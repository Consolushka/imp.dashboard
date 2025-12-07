
import 'package:flutter/material.dart';
import '../models/ranked_player_model.dart';

class LeaderboardCard extends StatelessWidget {
  final RankedPlayer rankedPlayer;
  final bool isTopThree;

  const LeaderboardCard({
    super.key,
    required this.rankedPlayer,
    this.isTopThree = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isTopThree ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isTopThree
            ? BorderSide(
          color: _getPositionColor(),
          width: 2,
        )
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Позиция с медалькой для топ-3
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isTopThree ? _getPositionColor() : Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isTopThree ? _getPositionColor() : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: isTopThree
                    ? Icon(
                  _getPositionIcon(),
                  color: Colors.white,
                  size: 24,
                )
                    : Text(
                  '${rankedPlayer.position}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Аватар игрока
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[50],
              ),
              child: const Icon(
                Icons.person,
                size: 20,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 16),

            // Информация об игроке
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rankedPlayer.player.fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isTopThree ? FontWeight.bold : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${rankedPlayer.gamesCount} ${_getGamesText(rankedPlayer.gamesCount)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // IMP значение
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _getImpBackgroundColor(),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getImpBorderColor(),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'IMP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rankedPlayer.avgImp >= 0
                        ? '+${rankedPlayer.avgImp.toStringAsFixed(1)}'
                        : '${rankedPlayer.avgImp.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getImpTextColor(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor() {
    switch (rankedPlayer.position) {
      case 1:
        return Colors.amber[600]!; // Золото
      case 2:
        return Colors.grey[400]!; // Серебро
      case 3:
        return Colors.brown[400]!; // Бронза
      default:
        return Colors.grey[300]!;
    }
  }

  IconData _getPositionIcon() {
    switch (rankedPlayer.position) {
      case 1:
        return Icons.looks_one;
      case 2:
        return Icons.looks_two;
      case 3:
        return Icons.looks_3;
      default:
        return Icons.person;
    }
  }

  String _getGamesText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'игра';
    } else if ([2, 3, 4].contains(count % 10) && ![12, 13, 14].contains(count % 100)) {
      return 'игры';
    } else {
      return 'игр';
    }
  }

  Color _getImpBackgroundColor() {
    if (rankedPlayer.avgImp >= 10) return Colors.green[50]!;
    if (rankedPlayer.avgImp >= 5) return Colors.lightGreen[50]!;
    if (rankedPlayer.avgImp >= 0) return Colors.grey[50]!;
    if (rankedPlayer.avgImp >= -5) return Colors.orange[50]!;
    return Colors.red[50]!;
  }

  Color _getImpBorderColor() {
    if (rankedPlayer.avgImp >= 10) return Colors.green[200]!;
    if (rankedPlayer.avgImp >= 5) return Colors.lightGreen[200]!;
    if (rankedPlayer.avgImp >= 0) return Colors.grey[200]!;
    if (rankedPlayer.avgImp >= -5) return Colors.orange[200]!;
    return Colors.red[200]!;
  }

  Color _getImpTextColor() {
    if (rankedPlayer.avgImp >= 10) return Colors.green[800]!;
    if (rankedPlayer.avgImp >= 5) return Colors.green[600]!;
    if (rankedPlayer.avgImp >= 0) return Colors.grey[700]!;
    if (rankedPlayer.avgImp >= -5) return Colors.orange[700]!;
    return Colors.red[700]!;
  }
}
