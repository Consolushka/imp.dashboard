import 'package:flutter/material.dart';
import '../core/di.dart';
import '../infra/statistics/client.dart';
import '../infra/statistics/leaderboard_filters_model.dart';
import '../models/tournament_model.dart';
import '../models/ranked_player_model.dart';
import '../models/pers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/error_dialog.dart';
import '../widgets/leaderboard_player_card.dart';

class LeaderboardScreen extends StatefulWidget {
  final Tournament? tournament;

  const LeaderboardScreen({
    super.key,
    this.tournament,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  StatisticsClient apiClient = DependencyInjection().getIt<StatisticsClient>();
  
  List<RankedPlayer> _players = [];
  bool _isLoading = true;
  
  // Параметры фильтрации
  String _selectedPer = fullGameImpPer.code;
  final String _selectedOrder = 'asc';
  final int _selectedLimit = 10;
  int _selectedMinGames = 1;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  void _loadLeaderboard() async {
    if (widget.tournament == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final filters = LeaderboardFilters(
        tournamentId: widget.tournament!.id,
        per: _selectedPer,
        limit: _selectedLimit,
        order: _selectedOrder,
        minGames: _selectedMinGames,
      );

      final leaderboard = await apiClient.getLeaderboard(filters);

      setState(() {
        _players = leaderboard;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Ошибка загрузки лидерборда',
          message: 'Не удалось загрузить лидерборд турнира.\n\nТехническая информация:\n$e',
          onRetry: _loadLeaderboard,
          retryButtonText: 'Попробовать снова',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboard,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _buildBody(),
    );
  }

  String _getTitle() {
    if (widget.tournament != null) {
      return 'Лидерборд ${widget.tournament!.name}';
    }
    return 'Лидерборд';
  }

  Widget _buildBody() {
    if (widget.tournament == null) {
      return _buildNoTournamentState();
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 2,
        ),
      );
    }

    if (_players.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => _loadLeaderboard(),
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          // Фильтры
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(context),
              vertical: 16,
            ),
            sliver: SliverToBoxAdapter(
              child: _buildFilters(),
            ),
          ),

          // Заголовок
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(context),
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Топ игроков турнира',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Рейтинг по среднему IMP (${_getPerDisplayName()})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 16)),

          // Список игроков
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(context),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final player = _players[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: LeaderboardCard(
                      rankedPlayer: player,
                      isTopThree: index < 3,
                    ),
                  );
                },
                childCount: _players.length,
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  size: 20,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 8),
                Text(
                  'Фильтры лидерборда',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Период IMP
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Период IMP:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedPer,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          fullGameImpPer,
                          benchImpPer,
                          startImpPer,
                        ].map((per) {
                          return DropdownMenuItem(
                            value: per.code,
                            child: Text(per.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPer = value;
                            });
                            _loadLeaderboard();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Минимум игр
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Мин. игр:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _selectedMinGames.toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) {
                          final minGames = int.tryParse(value) ?? _selectedMinGames;
                          setState(() {
                            _selectedMinGames = minGames;
                          });
                          _loadLeaderboard();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoTournamentState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.leaderboard_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Выберите турнир',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Для просмотра лидерборда необходимо выбрать турнир',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.leaderboard_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Лидерборд пуст',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'В турнире пока нет игроков с достаточным количеством игр',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return (width - 800) / 2;
    } else if (width > 800) {
      return width * 0.1;
    }
    return 16;
  }

  String _getPerDisplayName() {
    switch (_selectedPer) {
      case 'fullGame':
        return 'вся игра';
      case 'bench':
        return 'скамейка';
      case 'start':
        return 'старт';
      default:
        return _selectedPer;
    }
  }
}
