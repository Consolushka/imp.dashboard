import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:imp/models/player_stat_imp_model.dart';
import 'package:imp/widgets/error_dialog.dart';
import '../core/di.dart';
import '../infra/statistics/client.dart';
import '../models/game_model.dart';
import '../models/pers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/player_stats_table.dart';

class GameDetailScreen extends StatefulWidget {
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  static final List<ImpPer> _availablePers = [benchImpPer, startImpPer, fullGameImpPer];

  List<ImpPer> _selectedPers = [fullGameImpPer];

  StatisticsClient apiClient = DependencyInjection().getIt<StatisticsClient>();

  late Game _game;
  Map<int, List<PlayerStatImp>> _playerImps = {}; // IMP значения по ID игроков
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameStats();
  }

  void _loadGameStats() async {
    try {
      _game = await apiClient.game(widget.game.id);
      _loadPlayerImps();
    } on Exception catch (e) {
      if (mounted) {
        ErrorDialog.show(context, title: "Error", message: e.toString());
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadPlayerImps() async {
    List<int> ids =
        [..._game.teamStats![0].playerStats!, ..._game.teamStats![1].playerStats!].map((stat) => stat.id).toList();
    var res = await apiClient.imp(ids, _selectedPers.map((per) => per.code).toList());
    setState(() {
      _playerImps = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadGameStats();
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _buildBody(),
    );
  }

  String _getTitle() {
    if (widget.game.teamStats != null && widget.game.teamStats!.length >= 2) {
      final team1 = widget.game.teamStats![0];
      final team2 = widget.game.teamStats![1];
      return '${team1.team?.name ?? 'Команда 1'} vs ${team2.team?.name ?? 'Команда 2'}';
    }
    return widget.game.title;
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2));
    }

    // Определяем команды-победители и проигравшие
    final team1 = _game.teamStats![0];
    final team2 = _game.teamStats![1];
    final winnerTeam = team1.isWinner ? team1 : team2;
    final loserTeam = team1.isWinner ? team2 : team1;
    final winnerStats = team1.isWinner ? team1.playerStats! : team2.playerStats!;
    final loserStats = team1.isWinner ? team2.playerStats! : team1.playerStats!;
    winnerStats.sort((a, b) => b.playedSeconds.compareTo(a.playedSeconds));
    loserStats.sort((a, b) => b.playedSeconds.compareTo(a.playedSeconds));

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        _loadGameStats();
      },
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          // Заголовок и счет игры
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(context), vertical: 16),
            sliver: SliverToBoxAdapter(child: _buildGameHeader()),
          ),


          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(context), vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Card(
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
                            Icons.filter_list,
                            size: 20,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Периоды для расчета IMP',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomDropdown<ImpPer>.multiSelect(
                        items: _availablePers,
                        decoration: CustomDropdownDecoration(
                          closedFillColor: Colors.grey[50],
                          closedBorder: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                          closedBorderRadius: BorderRadius.circular(8),
                          expandedFillColor: Colors.white,
                          expandedBorder: Border.all(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          expandedBorderRadius: BorderRadius.circular(8),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          headerStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          listItemStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.analytics_outlined,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          expandedSuffixIcon: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.grey[600],
                          ),
                        ),
                        hintText: 'Выберите периоды для расчета',
                        initialItems: _selectedPers,
                        onListChanged: (value) async {
                          if (value.isNotEmpty) {
                            setState(() {
                              _selectedPers = value;
                            });
                            _loadPlayerImps();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Таблица команды-победителя (всегда первая)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(context)),
            sliver: SliverToBoxAdapter(
              child: PlayerStatsTable(
                teamName: winnerTeam.team?.name ?? 'Команда-победитель',
                teamScore: winnerTeam.score,
                isWinner: true,
                playerStats: winnerStats,
                playerImps: _playerImps,
                pers: _selectedPers,
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.symmetric(vertical: 12)),

          // Таблица команды-проигравшей (всегда вторая)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: _getHorizontalPadding(context)),
            sliver: SliverToBoxAdapter(
              child: PlayerStatsTable(
                teamName: loserTeam.team?.name ?? 'Команда-проигравшая',
                teamScore: loserTeam.score,
                isWinner: false,
                playerStats: loserStats,
                playerImps: _playerImps,
                pers: _selectedPers
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  double _getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) {
      return (width - 900) / 2; // Максимальная ширина таблиц 900px
    } else if (width > 800) {
      return width * 0.05; // 5% отступы по бокам
    }
    return 16; // Стандартные отступы для мобильных
  }

  Widget _buildGameHeader() {
    if (widget.game.teamStats == null || widget.game.teamStats!.length < 2) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(widget.game.title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
        ),
      );
    }

    final team1 = widget.game.teamStats![0];
    final team2 = widget.game.teamStats![1];
    final winner = team1.isWinner ? team1 : team2;
    final loser = team1.isWinner ? team2 : team1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Информация о турнире
            if (widget.game.tournament != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${widget.game.tournament!.league?.name ?? ''} • ${widget.game.tournament!.name}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Счет игры
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Команда-победитель
                _buildTeamScore(context, winner, isWinner: true),

                // Разделитель
                Text('—', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.grey)),

                // Команда-проигравший
                _buildTeamScore(context, loser, isWinner: false),
              ],
            ),

            const SizedBox(height: 16),

            // Дата и время
            Text(
              '${_formatDate()} в ${_formatTime()}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamScore(BuildContext context, dynamic teamStat, {required bool isWinner}) {
    return Column(
      children: [
        // Логотип команды
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: isWinner ? Colors.black : Colors.grey, width: isWinner ? 2 : 1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(Icons.sports_basketball, size: 24, color: isWinner ? Colors.black : Colors.grey),
        ),
        const SizedBox(height: 8),

        // Название команды
        Text(
          teamStat.team?.name ?? 'Команда ${teamStat.teamId}',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: isWinner ? FontWeight.w600 : FontWeight.normal),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),

        // Счет
        Text(
          '${teamStat.score}',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isWinner ? Colors.black : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _formatDate() {
    return '${widget.game.scheduledAt.day.toString().padLeft(2, '0')}.${widget.game.scheduledAt.month.toString().padLeft(2, '0')}.${widget.game.scheduledAt.year}';
  }

  String _formatTime() {
    return '${widget.game.scheduledAt.hour.toString().padLeft(2, '0')}:${widget.game.scheduledAt.minute.toString().padLeft(2, '0')}';
  }
}
