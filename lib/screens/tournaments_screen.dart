import 'package:flutter/material.dart';
import 'package:imp/widgets/error_dialog.dart';
import '../core/di.dart';
import '../infra/statistics/client.dart';
import '../models/league_model.dart';
import '../models/tournament_model.dart';
import '../widgets/tournament_card.dart';
import '../widgets/app_drawer.dart';
import 'games_screen.dart';

class TournamentsScreen extends StatefulWidget {
  final League? league;

  const TournamentsScreen({super.key, this.league});

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  StatisticsClient apiClient = DependencyInjection().getIt<StatisticsClient>();
  List<Tournament> _tournaments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTournaments();
  }

  void _loadTournaments() async {
    try{
      if (widget.league != null) {
        _tournaments = await apiClient.tournamentsByLeague(widget.league!.id);
      } else {
        _tournaments = await apiClient.tournaments();
      }
    } on Exception catch (e) {
      if (mounted) {
        ErrorDialog.show(context, title: "Ошибка", message: e.toString());
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onTournamentTap(Tournament tournament) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GamesScreen(tournament: tournament)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        leading:
            widget.league != null
                ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop())
                : null,
      ),
      drawer: const AppDrawer(),
      body: _buildBody(),
    );
  }

  String _getTitle() {
    if (widget.league != null) {
      return widget.league!.name;
    }
    return 'Все турниры';
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2));
    }

    if (_tournaments.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        _loadTournaments();
      },
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_getSubtitle(), style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(_getDescription(), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final tournament = _tournaments[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TournamentCard(
                    tournament: tournament,
                    onTap: () => _onTournamentTap(tournament),
                    showLeague: widget.league == null,
                  ),
                );
              }, childCount: _tournaments.length),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  String _getSubtitle() {
    if (widget.league != null) {
      return 'Турниры ${widget.league!.name}';
    }
    return 'Турниры';
  }

  String _getDescription() {
    if (widget.league != null) {
      return 'Найдено турниров: ${_tournaments.length}';
    }
    return 'Все доступные турниры из всех лиг';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_circle, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            widget.league != null ? 'Турниры не найдены' : 'Нет доступных турниров',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            widget.league != null ? 'В лиге ${widget.league!.name} пока нет турниров' : 'Попробуйте обновить страницу',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadTournaments();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Обновить'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
