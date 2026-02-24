import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../library/sorting/sorting.dart';
import '../models/game_team_player_stat_model.dart';
import '../models/pers.dart';

class PlayerStatsTable extends StatefulWidget {
  final String teamName;
  final int teamScore;
  final bool isWinner;
  final List<GameTeamPlayerStat> playerStats;
  final Map<int, Map<String, double>> playerImps;
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
  State<PlayerStatsTable> createState() => _PlayerStatsTableState();
}

class _PlayerStatsTableState extends State<PlayerStatsTable> {
  late final Sorting _minutesSorting;
  late final Sorting _plusMinusSorting;
  final List<Sorting> _persSorting = [];
  List<Sorting> sortingChain = [];

  bool _isSorted = false;

  @override
  void initState() {
    super.initState();
    _minutesSorting = Sorting(
      id: "Minutes",
      isAscending: true,
      callback: (isAscending) {
        int multiplier = isAscending ? 1 : -1;

        widget.playerStats.sort((a, b) => a.playedSeconds.compareTo(b.playedSeconds) * multiplier);
      },
    );
    _plusMinusSorting = Sorting(
      id: "PlusMinus",
      callback: (isAscending) {
        int multiplier = isAscending ? 1 : -1;

        widget.playerStats.sort((a, b) => a.plusMinus.compareTo(b.plusMinus) * multiplier);
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    _persSorting.clear();
    for (var per in widget.pers) {

      bool? isAscending;

      for (var sortingInstance in sortingChain) {
        if (sortingInstance.id == per.name) {
          isAscending = sortingInstance.isAscending;
        }
      }

      var perSorting = Sorting(
        id: per.name,
        isAscending: isAscending,
        callback: (isAscending) {
          int multiplier = isAscending ? 1 : -1;

          widget.playerStats.sort((a, b) {
            final aImps = widget.playerImps[a.id];
            final bImps = widget.playerImps[b.id];

            final aImp = aImps?[per.code] ?? 0.0;
            final bImp = bImps?[per.code] ?? 0.0;

            return aImp.compareTo(bImp) * multiplier;
          });
        },
      );
      _persSorting.add(perSorting);
    }

    sortingChain = [_minutesSorting, _plusMinusSorting];
    sortingChain.addAll(_persSorting);

    if (!_isSorted) {
      _isSorted = true;
      sortingChain.forEach((sorting) {
        if (sorting.isAscending != null) {
          sort(sorting);
          return;
        }
      });
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800; // Определяем мобильное устройство

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок команды
            _buildTeamHeader(context),
            const SizedBox(height: 16),

            // Адаптивная таблица
            isMobile ? _buildScrollableTable(context) : _buildResponsiveTable(context),
          ],
        ),
      ),
    );
  }

  // Горизонтально прокручиваемая таблица для мобильных
  Widget _buildScrollableTable(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFixedPlayerColumn(context), // Фиксированная колонка игрока
        Expanded(
          child: _buildScrollableStatsColumns(context), // Прокручиваемые колонки статистики
        ),
      ],
    );
  }

  // Отзывчивая таблица для больших экранов
  Widget _buildResponsiveTable(BuildContext context) {
    return Column(
      children: [
        _buildResponsiveTableHeader(context), // Используем заголовок для отзывчивой таблицы
        const SizedBox(height: 8),
        ...widget.playerStats.map((stat) => _buildResponsivePlayerRow(context, stat)), // Используем строки для отзывчивой таблицы
      ],
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
            border: Border.all(color: widget.isWinner ? Colors.black : Colors.grey, width: widget.isWinner ? 2 : 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.sports_basketball, size: 20, color: widget.isWinner ? Colors.black : Colors.grey),
        ),
        const SizedBox(width: 12),

        // Название и счет команды
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.teamName,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: widget.isWinner ? FontWeight.bold : FontWeight.w500),
              ),
              Text(
                'Счет: ${widget.teamScore}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Статус команды
        if (widget.isWinner) ...[
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

  // Новый метод: Фиксированная колонка для аватара и имени игрока на мобильных
  Widget _buildFixedPlayerColumn(BuildContext context) {
    return Column(
      children: [
        // Фиксированный заголовок для игрока
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
          child: const Row(
            children: [
              SizedBox(width: 40), // Заглушка для аватара
              SizedBox(width: 12), // Промежуток
              SizedBox(
                width: 120, // Фиксированная ширина для имени игрока
                child: Text(
                  'Игрок',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        // Фиксированные строки игроков
        ...widget.playerStats.map((stat) => _buildFixedPlayerRow(context, stat)),
      ],
    );
  }

  // Новый метод: Отдельная фиксированная строка для аватара и имени игрока на мобильных
  Widget _buildFixedPlayerRow(BuildContext context, GameTeamPlayerStat stat) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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

          // Имя игрока (фиксированная ширина для мобильных)
          SizedBox(
            width: 120,
            child: Text(
              stat.player?.fullName ?? 'Игрок ${stat.playerId}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Новый метод: Прокручиваемые колонки для всей статистики, кроме имени/аватара игрока, на мобильных
  Widget _buildScrollableStatsColumns(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // Прокручиваемый заголовок для статистики
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Время
                IconButton(
                  onPressed: () {
                    sort(_minutesSorting);
                  },
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(child: Icon(size: 15, _getSortingIcon(_minutesSorting))),
                      SizedBox(
                        width: 60,
                        child: Text(
                          'Время',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // +/-
                IconButton(
                  onPressed: () {
                    sort(_plusMinusSorting);
                  },
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(child: Icon(size: 15, _getSortingIcon(_plusMinusSorting))),
                      SizedBox(
                        width: 50,
                        child: Text(
                          '+/–',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // IMP
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "IMP",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < widget.pers.length; i++) ...[
                          IconButton(
                            onPressed: () {
                              var persSorting = _persSorting[i];
                              sort(persSorting);
                            },
                            icon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(child: Icon(size: 15, _getSortingIcon(_persSorting[i]))),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    widget.pers[i].toString(),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i < widget.pers.length - 1) const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ],
                ),

                // PTS, FG%, REB, AST, BLK, STL, TOV
                SizedBox(
                  width: 60,
                  child: Text(
                    'PTS',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'FG%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'REB',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'AST',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'BLK',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'STL',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    'TOV',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Прокручиваемые строки статистики игроков
          ...widget.playerStats.map((stat) => _buildScrollableStatsRow(context, stat)),
        ],
      ),
    );
  }

  // Новый метод: Отдельная прокручиваемая строка для всей статистики игрока, кроме имени/аватара, на мобильных
  Widget _buildScrollableStatsRow(BuildContext context, GameTeamPlayerStat stat) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
      child: Row(
        children: [
          // Время игры
          SizedBox(
            width: 60 + 15 + 8 + 8, // Убедитесь, что эта ширина соответствует ширине заголовка
            child: Text(
              _formatPlayTime(stat.playedSeconds),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(width: 8),

          // +/-
          SizedBox(
            width: 50 + 15 + 8 + 8, // Убедитесь, что эта ширина соответствует ширине заголовка
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: _getPlusMinusColor(stat.plusMinus),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                stat.plusMinus > 0 ? '+${stat.plusMinus}' : '${stat.plusMinus}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // IMP колонки
          ...widget.pers.expand((per) => _getPlayerImpPerSizedBox(context, stat.id, per)),

          // Очки
          SizedBox(
            width: 60,
            child: Text(
              stat.points.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // FG%
          SizedBox(
            width: 60,
            child: Text(
              '${(stat.fieldGoalsPercentage * 100).round()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Подборы
          SizedBox(
            width: 60,
            child: Text(
              stat.rebounds.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Передачи
          SizedBox(
            width: 60,
            child: Text(
              stat.assists.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Блоки
          SizedBox(
            width: 60,
            child: Text(
              stat.blocks.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Перехваты
          SizedBox(
            width: 60,
            child: Text(
              stat.steals.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Потери
          SizedBox(
            width: 60,
            child: Text(
              stat.turnovers.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Переименованный и модифицированный метод: Этот метод теперь отвечает только за заголовок отзывчивой (немобильной) таблицы
  Widget _buildResponsiveTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Аватарка
          const SizedBox(width: 40),
          const SizedBox(width: 12),

          // Игрок (Expanded для отзывчивой таблицы)
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
          IconButton(
            onPressed: () {
              sort(_minutesSorting);
            },
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(child: Icon(size: 15, _getSortingIcon(_minutesSorting))),

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
              ],
            ),
          ),

          const SizedBox(width: 8),

          // +/-
          IconButton(
            onPressed: () {
              sort(_plusMinusSorting);
            },
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(child: Icon(size: 15, _getSortingIcon(_plusMinusSorting))),

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
              ],
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
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < widget.pers.length; i++) ...[
                    IconButton(
                      onPressed: () {
                        var persSorting = _persSorting[i];
                        sort(persSorting);
                      },
                      icon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(child: Icon(size: 15, _getSortingIcon(_persSorting[i]))),

                          SizedBox(
                            width: 100,
                            child: Text(
                              widget.pers[i].toString(),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < widget.pers.length - 1) const SizedBox(width: 8),
                  ],
                ],
              ),
            ],
          ),

          SizedBox(
            width: 60,
            child: Text(
              'PTS',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            width: 60,
            child: Text(
              'FG%',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            width: 60,
            child: Text(
              'REB',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            width: 60,
            child: Text(
              'AST',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            width: 60,
            child: Text(
              'BLK',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            width: 60,
            child: Text(
              'STL',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            width: 60,
            child: Text(
              'TOV',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Переименованный и модифицированный метод: Этот метод теперь отвечает только за строки отзывчивой (немобильной) таблицы
  Widget _buildResponsivePlayerRow(BuildContext context, GameTeamPlayerStat stat) {
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

          // Имя игрока (Expanded для отзывчивой таблицы)
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
            width: 60 + 15 + 8 + 8, // Убедитесь, что эта ширина соответствует ширине заголовка
            child: Text(
              _formatPlayTime(stat.playedSeconds),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(width: 8),

          // +/-
          SizedBox(
            width: 50 + 15 + 8 + 8, // Убедитесь, что эта ширина соответствует ширине заголовка
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

          // IMP колонки
          ...widget.pers.expand((per) => _getPlayerImpPerSizedBox(context, stat.id, per)),

          // Очки
          SizedBox(
            width: 60,
            child: Text(
              stat.points.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // FG%
          SizedBox(
            width: 60,
            child: Text(
              '${(stat.fieldGoalsPercentage * 100).round()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Подборы
          SizedBox(
            width: 60,
            child: Text(
              stat.rebounds.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Передачи
          SizedBox(
            width: 60,
            child: Text(
              stat.assists.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Блоки
          SizedBox(
            width: 60,
            child: Text(
              stat.blocks.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Перехваты
          SizedBox(
            width: 60,
            child: Text(
              stat.steals.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Потери
          SizedBox(
            width: 60,
            child: Text(
              stat.turnovers.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSortingIcon(Sorting sorting) {
    Sorting? instance;

    for (var sortingInstance in sortingChain) {
      if (sortingInstance.id == sorting.id) {
        instance = sorting;
      }
    }

    if (instance == null) {
      throw Exception("Cannot find sorting instance");
    }

    if (instance.isAscending == null) {
      return FaIcon(FontAwesomeIcons.sort).icon!;
    }

    return instance.isAscending!
        ? FaIcon(FontAwesomeIcons.arrowUpShortWide).icon!
        : FaIcon(FontAwesomeIcons.arrowUpWideShort).icon!;
  }

  void sort(Sorting sorting) {
    for (var sortingInstance in sortingChain) {
      if (sortingInstance.id != sorting.id) {
        sortingInstance.disable();
      } else {
        sortingInstance.toggle();
      }
    }

    setState(() {});
  }

  List<Widget> _getPlayerImpPerSizedBox(BuildContext context, int playerStatId, ImpPer per) {
    final imp = _getImpForPlayerByPer(playerStatId, per);
    final isLast = widget.pers.last == per;

    return [
      SizedBox(
        width: 100 + 15 + 8 + 8,
        child:
            imp != null
                ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(color: _getImpColor(imp), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    imp > 0 ? '+${imp.toStringAsFixed(1)}' : imp.toStringAsFixed(1),
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
      if (!isLast) const SizedBox(width: 8),
    ];
  }

  // Получаем IMP для указанного периода
  double? _getImpForPlayerByPer(int playerStatId, ImpPer per) {
    final imps = widget.playerImps[playerStatId];
    if (imps == null) return null;

    return imps[per.code];
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
