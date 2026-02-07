import 'package:flutter/material.dart';
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
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
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
                      Icon(
                        _selectedOrder == 'desc' ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Рейтинг по среднему IMP (${_getPerDisplayName()}) • Показано ${_players.length} из ${_selectedLimit}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
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
                      key: ValueKey('player-${player.player.id}-${_selectedPer}-${_selectedTeamId ?? 'all'}'),
                      rankedPlayer: player,
                      isTopThree: index < 3,
                      tournamentId: widget.tournament!.id,
                      per: _selectedPer,
                      teamId: _selectedTeamId,
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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, size: 20, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  'Фильтры лидерборда',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[800]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Выбор команды
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Команда:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  value: _selectedTeamId,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<int?>(value: null, child: Text('Все команды')),
                    ..._getSortedTeams().map((team) {
                      return DropdownMenuItem<int?>(
                        value: team.id,
                        child: Text(team.name, overflow: TextOverflow.ellipsis),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTeamId = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Период IMP и Порядок сортировки
            if (isMobile) ...[
              // Мобильная версия - один столбец
              _buildFilterField(
                'Период IMP:',
                DropdownButtonFormField<String>(
                  value: _selectedPer,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items:
                      [fullGameImpPer, benchImpPer, startImpPer].map((per) {
                        return DropdownMenuItem(value: per.code, child: Text(per.name));
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPer = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterField(
                'Порядок:',
                DropdownButtonFormField<String>(
                  value: _selectedOrder,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'desc',
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_downward, size: 16),
                          const SizedBox(width: 8),
                          const Text('По убыванию'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'asc',
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_upward, size: 16),
                          const SizedBox(width: 8),
                          const Text('По возрастанию'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedOrder = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterField(
                'Мин. игр:',
                TextFormField(
                  controller: _minGamesController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    hintText: 'от 1 до 100',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterField(
                'Минут в матче: ${_selectedMinutes.start.round()} - ${_selectedMinutes.end.round()}',
                Column(
                  children: [
                    RangeSlider(
                      values: _selectedMinutes,
                      min: 0,
                      max: regulationDuration.ceilToDouble(),
                      divisions: regulationDuration,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey[300],
                      labels: RangeLabels(
                        _selectedMinutes.start.round().toString(),
                        _selectedMinutes.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _selectedMinutes = values;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0 мин', style: Theme.of(context).textTheme.bodySmall),
                          Text('$regulationDuration мин', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterField(
                'Кол-во игроков:',
                DropdownButtonFormField<int>(
                  value: _selectedLimit,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items:
                      [10, 20, 30, 50, 100].map((limit) {
                        return DropdownMenuItem(value: limit, child: Text('Топ $limit'));
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedLimit = value;
                      });
                    }
                  },
                ),
              ),
            ] else ...[
              // Десктопная версия - два столбца
              Row(
                children: [
                  Expanded(
                    child: _buildFilterField(
                      'Период IMP:',
                      DropdownButtonFormField<String>(
                        value: _selectedPer,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items:
                            [fullGameImpPer, benchImpPer, startImpPer].map((per) {
                              return DropdownMenuItem(value: per.code, child: Text(per.name));
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPer = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFilterField(
                      'Порядок:',
                      DropdownButtonFormField<String>(
                        value: _selectedOrder,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'desc',
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_downward, size: 16),
                                const SizedBox(width: 8),
                                const Text('По убыванию'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'asc',
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_upward, size: 16),
                                const SizedBox(width: 8),
                                const Text('По возрастанию'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedOrder = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterField(
                      'Мин. игр:',
                      TextFormField(
                        controller: _minGamesController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          hintText: 'от 1 до 100',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFilterField(
                      'Кол-во игроков:',
                      DropdownButtonFormField<int>(
                        value: _selectedLimit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items:
                            [10, 20, 30, 50, 100].map((limit) {
                              return DropdownMenuItem(value: limit, child: Text('Топ $limit'));
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedLimit = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFilterField(
                'Минут в матче: ${_selectedMinutes.start.round()} - ${_selectedMinutes.end.round()}',
                Column(
                  children: [
                    RangeSlider(
                      values: _selectedMinutes,
                      min: 0,
                      max: regulationDuration.ceilToDouble(),
                      divisions: regulationDuration,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey[300],
                      labels: RangeLabels(
                        _selectedMinutes.start.round().toString(),
                        _selectedMinutes.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _selectedMinutes = values;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0 мин', style: Theme.of(context).textTheme.bodySmall),
                          Text('$regulationDuration мин', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Кнопка обновления
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUpdating ? null : _updateFiltersAndReload,
                icon:
                    _isUpdating
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                        : const Icon(Icons.refresh),
                label: Text(_isUpdating ? 'Обновление...' : 'Обновить лидерборд'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Информация о текущих настройках
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                'Показать ${_getOrderDisplayText()} ${_selectedLimit} игроков${_selectedTeamId != null ? " выбранной команды" : ""} с минимум ${_selectedMinGames} играми (от ${_selectedMinutes.start.round()} до ${_selectedMinutes.end.round()} мин) по IMP (${_getPerDisplayName()})',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[700], fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный метод для создания полей фильтров
  Widget _buildFilterField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  // Метод для получения отсортированных команд по алфавиту
  List<Team> _getSortedTeams() {
    final sortedTeams = List<Team>.from(_teams);
    sortedTeams.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sortedTeams;
  }

  String _getOrderDisplayText() {
    return _selectedOrder == 'desc' ? 'лучших' : 'худших';
  }

  Widget _buildNoTournamentState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.leaderboard_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Выберите турнир', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            'Для просмотра лидерборда необходимо выбрать турнир',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
          const Icon(Icons.leaderboard_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Лидерборд пуст', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            'В турнире пока нет игроков с достаточным количеством игр',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
