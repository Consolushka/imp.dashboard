
import 'package:flutter/material.dart';
import 'package:imp/widgets/error_dialog.dart';
import '../core/di.dart';
import '../infra/statistics/client.dart';
import '../infra/statistics/paginated_response.dart';
import '../models/tournament_model.dart';
import '../models/game_model.dart';
import '../widgets/game_card.dart';
import '../widgets/app_drawer.dart';
import 'game_details_screen.dart';

class GamesScreen extends StatefulWidget {
  final Tournament? tournament;
  final bool isRecentGames;

  const GamesScreen({
    super.key,
    this.tournament,
    this.isRecentGames = false,
  });

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  StatisticsClient apiClient = DependencyInjection().getIt<StatisticsClient>();
  List<Game> _games = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;

  // Pagination data
  int _currentPage = 1;
  // int _lastPage = 1;
  int _total = 0;
  bool _hasNextPage = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadGames();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreGames();
    }
  }

  void _loadGames({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _games.clear();
      });
    }

    try {
      PaginatedResponse<Game> response;

      if (widget.tournament != null) {
        response = await apiClient.gamesByTournamentPaginated(widget.tournament!.id, _currentPage);
      } else if (widget.isRecentGames) {
        response = await apiClient.gamesPaginated(_currentPage);
      } else {
        // Fallback для обычных игр
        response = await apiClient.gamesPaginated(_currentPage);
      }

      setState(() {
        if (refresh) {
          _games = response.data;
        } else {
          _games.addAll(response.data);
        }

        _currentPage = response.currentPage;
        // _lastPage = response.lastPage;
        _total = response.total;
        _hasNextPage = response.hasNextPage;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });

      if (mounted){
        ErrorDialog.show(context, title: "Ошибка", message: e.toString());
      }
    }
  }

  void _loadMoreGames() {
    if (_isLoadingMore || !_hasNextPage) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    _loadGames();
  }

  void _onGameTap(Game game) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameDetailScreen(game: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        leading: (widget.tournament != null || widget.isRecentGames)
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadGames(refresh: true),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _buildBody(),
    );
  }

  String _getTitle() {
    if (widget.tournament != null) {
      return widget.tournament!.name;
    } else if (widget.isRecentGames) {
      return 'Последние игры';
    }
    return 'Игры';
  }

  Widget _buildBody() {
    if (_isLoading && _games.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 2,
        ),
      );
    }

    if (_games.isEmpty && !_isLoading) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadGames(refresh: true);
      },
      color: Colors.black,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getSubtitle(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getDescription(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(context),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index == _games.length) {
                    // Показываем индикатор загрузки в конце списка
                    return _buildLoadingMoreIndicator();
                  }

                  final game = _games[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GameCard(
                      game: game,
                      onTap: () => _onGameTap(game),
                      showTournament: widget.tournament == null,
                    ),
                  );
                },
                childCount: _games.length + (_isLoadingMore || _hasNextPage ? 1 : 0),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 2,
          ),
        ),
      );
    } else if (_hasNextPage) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: OutlinedButton(
            onPressed: _loadMoreGames,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
            ),
            child: const Text('Загрузить ещё'),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Все игры загружены',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
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

  String _getSubtitle() {
    if (widget.tournament != null) {
      return 'Игры турнира';
    } else if (widget.isRecentGames) {
      return 'Последние результаты';
    }
    return 'Игры';
  }

  String _getDescription() {
    if (_total > 0) {
      if (widget.tournament != null) {
        return 'Показано ${_games.length} из $_total игр';
      } else if (widget.isRecentGames) {
        return 'Показано ${_games.length} из $_total последних игр';
      }
      return 'Показано ${_games.length} из $_total игр';
    }

    if (widget.tournament != null) {
      return 'Загружаются игры турнира...';
    } else if (widget.isRecentGames) {
      return 'Последние завершенные игры всех лиг';
    }
    return 'Все доступные игры';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sports_basketball_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyTitle(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyDescription(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _loadGames(refresh: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Обновить'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  String _getEmptyTitle() {
    if (widget.tournament != null) {
      return 'Игры не найдены';
    } else if (widget.isRecentGames) {
      return 'Нет последних игр';
    }
    return 'Нет доступных игр';
  }

  String _getEmptyDescription() {
    if (widget.tournament != null) {
      return 'В турнире ${widget.tournament!.name} пока нет игр';
    } else if (widget.isRecentGames) {
      return 'Пока нет завершенных игр для отображения';
    }
    return 'Попробуйте обновить страницу';
  }
}
