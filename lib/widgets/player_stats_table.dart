import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
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

  // Table dimensions
  static const double _cellHeight = 60.0;
  static const double _columnTitleHeight = 70.0;
  static const double _rowTitleWidth = 160.0;

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
      for (var sorting in sortingChain) {
        if (sorting.isAscending != null) {
          sort(sorting);
          break;
        }
      }
    }

    final tableHeight = _columnTitleHeight + (widget.playerStats.length * _cellHeight);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeamHeader(context),
            const SizedBox(height: 16),
            SizedBox(
              height: tableHeight,
              child: _buildStickyTable(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyTable(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final columns = _getTableColumns();

        // Вычисляем минимальную ширину всей таблицы
        double minTotalWidth = _rowTitleWidth;
        for (var col in columns) {
          minTotalWidth += col.width;
        }

        // Вычисляем коэффициент масштабирования, если места больше чем нужно
        double scaleFactor = 1.0;
        if (availableWidth > minTotalWidth) {
          scaleFactor = availableWidth / minTotalWidth;
        }

        final scaledRowTitleWidth = _rowTitleWidth * scaleFactor;
        final scaledColumnWidths = columns.map((c) => c.width * scaleFactor).toList();

        return StickyHeadersTable(
          columnsLength: columns.length,
          rowsLength: widget.playerStats.length,
          columnsTitleBuilder: (i) => _buildColumnHeader(context, columns[i], scaledColumnWidths[i]),
          rowsTitleBuilder: (i) => _buildRowHeader(context, widget.playerStats[i]),
          contentCellBuilder: (j, i) => _buildContentCell(context, widget.playerStats[i], columns[j], scaledColumnWidths[j]),
          legendCell: _buildLegendCell(context),
          cellDimensions: CellDimensions.variableColumnWidth(
            columnWidths: scaledColumnWidths,
            contentCellHeight: _cellHeight,
            stickyLegendWidth: scaledRowTitleWidth,
            stickyLegendHeight: _columnTitleHeight,
          ),
        );
      },
    );
  }

  Widget _buildLegendCell(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4)),
      ),
      alignment: Alignment.center,
      child: Text(
        'Игрок',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildRowHeader(BuildContext context, GameTeamPlayerStat stat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 0.5)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[50],
            ),
            child: const Icon(Icons.person, size: 16, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Expanded(
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

  Widget _buildColumnHeader(BuildContext context, _TableColumn col, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: col.sorting != null
          ? InkWell(
              onTap: () => sort(col.sorting!),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(_getSortingIcon(col.sorting!), size: 12, color: Colors.grey[700]),
                  const SizedBox(height: 4),
                  Text(
                    col.title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                col.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  Widget _buildContentCell(BuildContext context, GameTeamPlayerStat stat, _TableColumn col, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 0.5)),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: _buildCellValue(context, stat, col, width),
    );
  }

  Widget _buildCellValue(BuildContext context, GameTeamPlayerStat stat, _TableColumn col, double width) {
    const double fontSize = 12.0;
    switch (col.type) {
      case _ColumnType.time:
        return Text(
          _formatPlayTime(stat.playedSeconds),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize),
        );
      case _ColumnType.plusMinus:
        return Container(
          width: width - 8,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: _getPlusMinusColor(stat.plusMinus),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            stat.plusMinus > 0 ? '+${stat.plusMinus}' : '${stat.plusMinus}',
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        );
      case _ColumnType.imp:
        final imp = _getImpForPlayerByPer(stat.id, col.extra as ImpPer);
        if (imp == null) {
          return Container(
            width: width - 8,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(6)),
            child: const Text(
              '—',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),
              textAlign: TextAlign.center,
            ),
          );
        }
        return Container(
          width: width - 8,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(color: _getImpColor(imp), borderRadius: BorderRadius.circular(6)),
          child: Text(
            imp > 0 ? '+${imp.toStringAsFixed(1)}' : imp.toStringAsFixed(1),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        );
      case _ColumnType.pts:
        return Text(stat.points.toString(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize));
      case _ColumnType.fg:
        return Text('${(stat.fieldGoalsPercentage * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize));
      case _ColumnType.reb:
        return Text(stat.rebounds.toString(), style: const TextStyle(fontSize: fontSize));
      case _ColumnType.ast:
        return Text(stat.assists.toString(), style: const TextStyle(fontSize: fontSize));
      case _ColumnType.blk:
        return Text(stat.blocks.toString(), style: const TextStyle(fontSize: fontSize));
      case _ColumnType.stl:
        return Text(stat.steals.toString(), style: const TextStyle(fontSize: fontSize));
      case _ColumnType.tov:
        return Text(stat.turnovers.toString(), style: const TextStyle(fontSize: fontSize));
    }
  }

  List<_TableColumn> _getTableColumns() {
    final List<_TableColumn> cols = [
      _TableColumn(title: 'Время', type: _ColumnType.time, sorting: _minutesSorting, width: 80),
      _TableColumn(title: '+/–', type: _ColumnType.plusMinus, sorting: _plusMinusSorting, width: 60),
    ];

    for (var i = 0; i < widget.pers.length; i++) {
      cols.add(_TableColumn(
        title: widget.pers[i].toString(),
        type: _ColumnType.imp,
        sorting: _persSorting[i],
        extra: widget.pers[i],
        width: 90,
      ));
    }

    cols.addAll([
      _TableColumn(title: 'PTS', type: _ColumnType.pts, width: 50),
      _TableColumn(title: 'FG%', type: _ColumnType.fg, width: 60),
      _TableColumn(title: 'REB', type: _ColumnType.reb, width: 50),
      _TableColumn(title: 'AST', type: _ColumnType.ast, width: 50),
      _TableColumn(title: 'BLK', type: _ColumnType.blk, width: 50),
      _TableColumn(title: 'STL', type: _ColumnType.stl, width: 50),
      _TableColumn(title: 'TOV', type: _ColumnType.tov, width: 50),
    ]);

    return cols;
  }

  Widget _buildTeamHeader(BuildContext context) {
    return Row(
      children: [
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.teamName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: widget.isWinner ? FontWeight.bold : FontWeight.w500),
              ),
              Text(
                'Счет: ${widget.teamScore}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        if (widget.isWinner) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
            child: Text(
              'ПОБЕДА',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 10),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getSortingIcon(Sorting sorting) {
    if (sorting.isAscending == null) return FontAwesomeIcons.sort;
    return sorting.isAscending! ? FontAwesomeIcons.arrowUpShortWide : FontAwesomeIcons.arrowUpWideShort;
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

  double? _getImpForPlayerByPer(int playerStatId, ImpPer per) {
    final imps = widget.playerImps[playerStatId];
    return imps?[per.code];
  }

  String _formatPlayTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getPlusMinusColor(int plusMinus) {
    if (plusMinus > 0) return Colors.green[100]!;
    if (plusMinus < 0) return Colors.red[100]!;
    return Colors.grey[200]!;
  }

  Color _getImpColor(double imp) {
    if (imp >= 15) return Colors.green[800]!;
    if (imp >= 10) return Colors.green[600]!;
    if (imp >= 5) return Colors.green[400]!;
    if (imp >= 0) return Colors.grey[600]!;
    if (imp >= -5) return Colors.orange[400]!;
    if (imp >= -10) return Colors.red[400]!;
    return Colors.red[800]!;
  }
}

enum _ColumnType { time, plusMinus, imp, pts, fg, reb, ast, blk, stl, tov }

class _TableColumn {
  final String title;
  final _ColumnType type;
  final Sorting? sorting;
  final dynamic extra;
  final double width;

  _TableColumn({required this.title, required this.type, this.sorting, this.extra, required this.width});
}
