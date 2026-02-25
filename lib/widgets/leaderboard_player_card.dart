
import 'package:flutter/material.dart';
import '../core/di.dart';
import '../infra/statistics/client.dart';
import '../models/player_recent_imp_model.dart';
import '../models/ranked_player_model.dart';

class LeaderboardCard extends StatefulWidget {
  final RankedPlayer rankedPlayer;
  final bool isTopThree;
  final int tournamentId;
  final String per;
  final int? teamId;

  const LeaderboardCard({
    super.key,
    required this.rankedPlayer,
    this.isTopThree = false,
    required this.tournamentId,
    required this.per,
    this.teamId,
  });

  @override
  State<LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard> {
  static const int _pageSize = 5;

  final StatisticsClient _apiClient = DependencyInjection().getIt<StatisticsClient>();

  bool _isExpanded = false;
  bool _isLoading = false;
  String? _errorMessage;
  List<GameImp> _games = [];
  int _total = 0;
  int _currentPage = 1;

  Future<void> _loadRecentImp({int page = 1}) async {
    if (_isLoading) return;
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final offset = (page - 1) * _pageSize;

    try {
      final result = await _apiClient.getRecentImpForPlayer(
        playerId: widget.rankedPlayer.player.id,
        tournamentId: widget.tournamentId,
        per: widget.per,
        teamId: widget.teamId,
        offset: offset,
        limit: _pageSize,
      );

      if (!mounted) return;

      setState(() {
        _total = result.meta.total;
        _currentPage = page;
        _games = result.games;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Не удалось загрузить IMP по последним играм';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.isTopThree ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: widget.isTopThree
            ? BorderSide(
                color: _getPositionColor(),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
            if (_isExpanded) {
              _currentPage = 1;
            }
          });
          if (_isExpanded && _games.isEmpty) {
            _loadRecentImp();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Позиция с медалькой для топ-3
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.isTopThree ? _getPositionColor() : Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: widget.isTopThree ? _getPositionColor() : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: widget.isTopThree
                          ? Icon(
                              _getPositionIcon(),
                              color: Colors.white,
                              size: 24,
                            )
                          : Text(
                              '${widget.rankedPlayer.position}',
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
                          widget.rankedPlayer.player.fullName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: widget.isTopThree ? FontWeight.bold : FontWeight.w500,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.rankedPlayer.gamesCount} ${_getGamesText(widget.rankedPlayer.gamesCount)}',
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
                          widget.rankedPlayer.avgImp >= 0
                              ? '+${widget.rankedPlayer.avgImp.toStringAsFixed(1)}'
                              : '${widget.rankedPlayer.avgImp.toStringAsFixed(1)}',
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
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildRecentImpPanel(context),
                crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPositionColor() {
    switch (widget.rankedPlayer.position) {
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
    switch (widget.rankedPlayer.position) {
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
    if (widget.rankedPlayer.avgImp >= 10) return Colors.green[50]!;
    if (widget.rankedPlayer.avgImp >= 5) return Colors.lightGreen[50]!;
    if (widget.rankedPlayer.avgImp >= 0) return Colors.grey[50]!;
    if (widget.rankedPlayer.avgImp >= -5) return Colors.orange[50]!;
    return Colors.red[50]!;
  }

  Color _getImpBorderColor() {
    if (widget.rankedPlayer.avgImp >= 10) return Colors.green[200]!;
    if (widget.rankedPlayer.avgImp >= 5) return Colors.lightGreen[200]!;
    if (widget.rankedPlayer.avgImp >= 0) return Colors.grey[200]!;
    if (widget.rankedPlayer.avgImp >= -5) return Colors.orange[200]!;
    return Colors.red[200]!;
  }

  Color _getImpTextColor() {
    if (widget.rankedPlayer.avgImp >= 10) return Colors.green[800]!;
    if (widget.rankedPlayer.avgImp >= 5) return Colors.green[600]!;
    if (widget.rankedPlayer.avgImp >= 0) return Colors.grey[700]!;
    if (widget.rankedPlayer.avgImp >= -5) return Colors.orange[700]!;
    return Colors.red[700]!;
  }

  Widget _buildRecentImpPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Последние игры (IMP)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
            else if (_errorMessage != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red[700]),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _loadRecentImp,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Повторить'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                ],
              )
            else if (_games.isEmpty)
              Text(
                'Нет данных по последним играм',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              )
            else
              _buildImpTilesRow(context),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  String _formatImpValue(double? imp) {
    if (imp == null) return '—';
    return imp >= 0 ? '+${imp.toStringAsFixed(1)}' : imp.toStringAsFixed(1);
  }

  Color _getImpValueColor(double? imp) {
    if (imp == null) return Colors.grey[600]!;
    if (imp >= 10) return Colors.green[800]!;
    if (imp >= 5) return Colors.green[600]!;
    if (imp >= 0) return Colors.grey[700]!;
    if (imp >= -5) return Colors.orange[700]!;
    return Colors.red[700]!;
  }

  Widget _buildImpTilesRow(BuildContext context) {
    final totalPages = (_total / _pageSize).ceil().clamp(1, 9999);
    final isFirst = _currentPage <= 1;
    final isLast = _currentPage >= totalPages;

    return Row(
      children: [
        IconButton(
          onPressed: isLast || _isLoading ? null : () => _loadRecentImp(page: _currentPage + 1),
          icon: const Icon(Icons.chevron_left),
          splashRadius: 18,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _games
                .map(
                  (game) => _buildImpTile(
                    context,
                    value: game.imp,
                    dateText: game.scheduledAt == null ? '—' : _formatDate(game.scheduledAt!),
                  ),
                )
                .toList(),
          ),
        ),
        IconButton(
          onPressed: isFirst || _isLoading ? null : () => _loadRecentImp(page: _currentPage - 1),
          icon: const Icon(Icons.chevron_right),
          splashRadius: 18,
        ),
      ],
    );
  }

  Widget _buildImpTile(BuildContext context, {required double? value, required String dateText}) {
    return Tooltip(
      message: dateText,
      triggerMode: TooltipTriggerMode.tap,
      child: SizedBox(
        width: 64,
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _getImpTileBackground(value),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getImpTileBorder(value), width: 1),
          ),
          child: Text(
            _formatImpValue(value),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getImpValueColor(value),
                ),
          ),
        ),
      ),
    );
  }

  Color _getImpTileBackground(double? imp) {
    if (imp == null) return Colors.grey[100]!;
    if (imp >= 10) return Colors.green[50]!;
    if (imp >= 5) return Colors.lightGreen[50]!;
    if (imp >= 0) return Colors.grey[50]!;
    if (imp >= -5) return Colors.orange[50]!;
    return Colors.red[50]!;
  }

  Color _getImpTileBorder(double? imp) {
    if (imp == null) return Colors.grey[200]!;
    if (imp >= 10) return Colors.green[200]!;
    if (imp >= 5) return Colors.lightGreen[200]!;
    if (imp >= 0) return Colors.grey[200]!;
    if (imp >= -5) return Colors.orange[200]!;
    return Colors.red[200]!;
  }
}
