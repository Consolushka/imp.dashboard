import 'package:flutter/material.dart';
import '../models/tournament_model.dart';

class TournamentCard extends StatelessWidget {
  final Tournament tournament;
  final VoidCallback? onTap;
  final bool showLeague;

  const TournamentCard({
    super.key,
    required this.tournament,
    this.onTap,
    this.showLeague = false,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Иконка турнира
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_tree_outlined,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Информация о турнире
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Название турнира
                        Text(
                          tournament.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        if (showLeague && tournament.league != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tournament.league!.name,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 8),
                        
                        // Даты турнира
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDateRange(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        
                        // Продолжительность регламента
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${tournament.regulationDuration} мин',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Стрелка перехода
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Статус турнира
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getTournamentStatus(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  // Информация о продолжительности
                  Text(
                    _getDurationText(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateRange() {
    final startDate = '${tournament.startAt.day.toString().padLeft(2, '0')}.${tournament.startAt.month.toString().padLeft(2, '0')}.${tournament.startAt.year}';
    final endDate = '${tournament.endAt.day.toString().padLeft(2, '0')}.${tournament.endAt.month.toString().padLeft(2, '0')}.${tournament.endAt.year}';
    
    if (tournament.startAt.year == tournament.endAt.year &&
        tournament.startAt.month == tournament.endAt.month &&
        tournament.startAt.day == tournament.endAt.day) {
      return startDate;
    }
    
    return '$startDate - $endDate';
  }

  String _getTournamentStatus() {
    final now = DateTime.now();
    
    if (now.isBefore(tournament.startAt)) {
      return 'ПРЕДСТОИТ';
    } else if (now.isAfter(tournament.endAt)) {
      return 'ЗАВЕРШЕН';
    } else {
      return 'ИДЕТ';
    }
  }

  Color _getStatusColor() {
    final now = DateTime.now();
    
    if (now.isBefore(tournament.startAt)) {
      return Colors.grey; // Предстоит
    } else if (now.isAfter(tournament.endAt)) {
      return Colors.black; // Завершен
    } else {
      return Colors.black87; // Идет
    }
  }

  String _getDurationText() {
    final duration = tournament.endAt.difference(tournament.startAt);
    final days = duration.inDays;
    
    if (days < 1) {
      return '1 день';
    } else if (days < 30) {
      return '$days дн.';
    } else {
      final months = (days / 30).round();
      return '$months мес.';
    }
  }
}
