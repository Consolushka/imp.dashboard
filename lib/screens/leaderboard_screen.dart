import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/di.dart';
import '../infra/statistics/client.dart';
import '../models/team_model.dart';
import '../models/tournament_model.dart';
import '../models/ranked_player_model.dart';
import '../infra/statistics/leaderboard_filters_model.dart';
import '../models/pers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/error_dialog.dart';
import '../widgets/leaderboard_player_card.dart';

class LeaderboardScreen extends StatefulWidget {
  final Tournament? tournament;

  const LeaderboardScreen({super.key, this.tournament});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  StatisticsClient apiClient = DependencyInjection().getIt<StatisticsClient>();

  List<RankedPlayer> _players = [];
  List<Team> _teams = []; // Добавляем список команд
  bool _isLoading = true;
  bool _isUpdating = false; // Для показа загрузки при обновлении

  // Контроллер для поля минимальных игр
  late TextEditingController _minGamesController;

  // Параметры фильтрации
  String _selectedPer = fullGameImpPer.code;
  String _selectedOrder = 'asc';
  int _selectedLimit = 10;
  int _selectedMinGames = 1;
  int? _selectedTeamId;
  bool _useReliability = false;
  late RangeValues _selectedMinutes;

  int regulationDuration = 40;

  @override
  void initState() {
    super.initState();
    _minGamesController = TextEditingController(text: _selectedMinGames.toString());
    if (widget.tournament != null) {
      regulationDuration = widget.tournament!.regulationDuration;
    }
    _selectedMinutes = RangeValues(0, regulationDuration.ceilToDouble());
    _loadTeams();
    _loadLeaderboard();
  }

  @override
  void dispose() {
    _minGamesController.dispose();
    super.dispose();
  }

  void _loadLeaderboard({bool isUpdate = false}) async {
    if (widget.tournament == null) {
      setState(() {
        _isLoading = false;
        _isUpdating = false;
      });
      return;
    }

    setState(() {
      if (isUpdate) {
        _isUpdating = true;
      } else {
        _isLoading = true;
      }
    });

    try {
      final filters = LeaderboardFilters(
        tournamentId: widget.tournament!.id,
        per: _selectedPer,
        limit: _selectedLimit,
        order: _selectedOrder,
        minGames: _selectedMinGames,
        teamId: _selectedTeamId,
        minMinutes: _selectedMinutes.start.round(),
        maxMinutes: _selectedMinutes.end.round(),
        useReliability: _useReliability,
        maxPossibleMinutes: regulationDuration,
      );

      final leaderboard = await apiClient.getLeaderboard(filters);

      setState(() {
        _players = leaderboard;
        _isLoading = false;
        _isUpdating = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isUpdating = false;
      });

      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Ошибка загрузки лидерборда',
          message: 'Не удалось загрузить лидерборд турнира.\n\nТехническая информация:\n$e',
          onRetry: () => _loadLeaderboard(),
          retryButtonText: 'Попробовать снова',
        );
      }
    }
  }

  void _updateFiltersAndReload() {
    // Обновляем минимальные игры из поля ввода
    final minGames = int.tryParse(_minGamesController.text) ?? 1;
    _selectedMinGames = minGames.clamp(1, 100);

    // Обновляем поле если значение было некорректным
    if (_minGamesController.text != _selectedMinGames.toString()) {
      _minGamesController.text = _selectedMinGames.toString();
    }

    // Перезагружаем лидерборд с обновленными фильтрами
    _loadLeaderboard(isUpdate: true);
  }

  void _loadTeams() async {
    if (widget.tournament == null) return;
    try {
      final teams = await apiClient.getTeamByTournament(widget.tournament!.id);
      setState(() {
        _teams = teams;
      });
    } catch (e) {
      print('Ошибка загрузки команд: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              if (widget.tournament != null) {
                context.go('/tournament/${widget.tournament!.id}/games', extra: widget.tournament);
              } else {
                context.go('/');
              }
            }
          },
        ),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => _loadLeaderboard())],
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
      return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2));
    }

    return RefreshIndicator(
      onRefresh: () async => _loadLeaderboard(),
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          // Фильтры
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(context), vertical: 16),
            sliver: SliverToBoxAdapter(child: _buildFilters()),
          ),

          // Заголовок
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(context)),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedOrder == 'desc' ? 'Лучшие игроки турнира' : 'Игроки турнира (по возрастанию)',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Найдено: ${_players.length} чел.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.timer_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Регламент: $regulationDuration мин.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(top: 16)),

          // Индикатор обновления
          if (_isUpdating) ...[
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(context)),
              sliver: const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)),
                ),
              ),
            ),
          ],

                      // Список игроков или пустое состояние
                    if (_players.isEmpty && !_isUpdating) ...[
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(context)),
                        sliver: SliverToBoxAdapter(child: _buildEmptyState()),
                      ),
                    ] else if (!_isUpdating) ...[
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(context)),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final player = _players[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: LeaderboardCard(
                                key: ValueKey('player-${player.player.id}-${_selectedPer}-${_selectedTeamId ?? 'all'}-${_useReliability}'),
                                rankedPlayer: player,
                                isTopThree: index < 3,
                                tournamentId: widget.tournament!.id,
                                per: _selectedPer,
                                teamId: _selectedTeamId,
                                useReliability: _useReliability,
                              ),
                            );
                          }, childCount: _players.length),
                        ),
                      ),
                    ],
                    const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.filter_list, size: 20),
                const SizedBox(width: 8),
                Text('Фильтры и настройки', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),

            // Верхний ряд: Период и Порядок
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Expanded(child: _buildPeriodDropdown()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildOrderDropdown()),
                  ],
                );
              }
              return Column(
                children: [
                  _buildPeriodDropdown(),
                  const SizedBox(height: 16),
                  _buildOrderDropdown(),
                ],
              );
            }),

            const SizedBox(height: 16),

            // Средний ряд: Команда и Лимит
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Expanded(child: _buildTeamDropdown()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildLimitDropdown()),
                  ],
                );
              }
              return Column(
                children: [
                  _buildTeamDropdown(),
                  const SizedBox(height: 16),
                  _buildLimitDropdown(),
                ],
              );
            }),

            const SizedBox(height: 16),

            // Нижний ряд: Мин. игры и Минуты
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildMinGamesField()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMinutesRange()),
                  ],
                );
              }
              return Column(
                children: [
                  _buildMinGamesField(),
                  const SizedBox(height: 16),
                  _buildMinutesRange(),
                ],
              );
            }),

            const Divider(height: 32),

            // Опции: Reliability
            _buildReliabilityToggle(),

            const SizedBox(height: 16),

            // Кнопка применения
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _updateFiltersAndReload,
                icon: const Icon(Icons.refresh),
                label: const Text('Применить фильтры'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPer,
      decoration: const InputDecoration(
        labelText: 'Период расчета',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        DropdownMenuItem(value: fullGameImpPer.code, child: Text(fullGameImpPer.name)),
        DropdownMenuItem(value: startImpPer.code, child: Text(startImpPer.name)),
        DropdownMenuItem(value: benchImpPer.code, child: Text(benchImpPer.name)),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedPer = value);
        }
      },
    );
  }

  Widget _buildOrderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedOrder,
      decoration: const InputDecoration(
        labelText: 'Порядок',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'asc', child: Text('По возрастанию (худшие)')),
        DropdownMenuItem(value: 'desc', child: Text('По убыванию (лучшие)')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedOrder = value);
        }
      },
    );
  }

  Widget _buildLimitDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedLimit,
      decoration: const InputDecoration(
        labelText: 'Показывать игроков',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 5, child: Text('Топ 5')),
        DropdownMenuItem(value: 10, child: Text('Топ 10')),
        DropdownMenuItem(value: 20, child: Text('Топ 20')),
        DropdownMenuItem(value: 50, child: Text('Топ 50')),
        DropdownMenuItem(value: 100, child: Text('Топ 100')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedLimit = value);
        }
      },
    );
  }

  Widget _buildTeamDropdown() {
    return DropdownButtonFormField<int?>(
      value: _selectedTeamId,
      decoration: const InputDecoration(
        labelText: 'Команда',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('Все команды')),
        ..._teams.map((team) => DropdownMenuItem(value: team.id, child: Text(team.name))),
      ],
      onChanged: (value) {
        setState(() => _selectedTeamId = value);
      },
    );
  }

  Widget _buildMinGamesField() {
    return TextFormField(
      controller: _minGamesController,
      decoration: const InputDecoration(
        labelText: 'Мин. игр',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        helperText: 'Минимум 1 игра',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildMinutesRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Игровое время (мин)', style: Theme.of(context).textTheme.bodySmall),
            Text(
              '${_selectedMinutes.start.round()} - ${_selectedMinutes.end.round()}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        RangeSlider(
          values: _selectedMinutes,
          min: 0,
          max: regulationDuration.ceilToDouble(),
          divisions: regulationDuration,
          activeColor: Colors.black,
          inactiveColor: Colors.grey[300],
          onChanged: (values) {
            setState(() => _selectedMinutes = values);
          },
        ),
      ],
    );
  }

  Widget _buildReliabilityToggle() {
    return SwitchListTile(
      value: _useReliability,
      onChanged: (value) {
        setState(() => _useReliability = value);
      },
      title: const Text('Достоверность (Reliability)'),
      subtitle: const Text('Взвешенный расчет с учетом времени на площадке'),
      activeColor: Colors.black,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_search_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Игроки не найдены',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Попробуйте изменить параметры фильтрации или выберите другой турнир',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNoTournamentState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Турнир не выбран'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.go('/tournaments'),
            child: const Text('Перейти к списку турниров'),
          ),
        ],
      ),
    );
  }

  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return (width - 900) / 2;
    if (width > 800) return width * 0.05;
    return 16;
  }
}
