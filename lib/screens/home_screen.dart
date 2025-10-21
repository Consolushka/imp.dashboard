import 'package:flutter/material.dart';
import 'package:imp/widgets/error_dialog.dart';
import '../infra/statistics/client.dart';
import '../core/di.dart';
import '../models/league_model.dart';
import '../widgets/league_card.dart';
import '../widgets/app_drawer.dart';
import 'tournaments_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StatisticsClient apiClient = DependencyInjection().getIt<StatisticsClient>();

  List<League> _leagues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeagues();
  }

  // Временные тестовые данные - замените на реальные API-вызовы
  void _loadLeagues() async {
    try {
      _leagues = await apiClient.leagues();
    } on Exception catch (e) {
      if (mounted){
        ErrorDialog.show(context, title: "Ошибка", message: e.toString());
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onLeagueTap(League league) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TournamentsScreen(league: league)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('IMP')), drawer: const AppDrawer(), body: _buildBody());
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2));
    }

    if (_leagues.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        _loadLeagues();
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
                  Text('Лиги', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Выберите лигу для просмотра турниров и статистики',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getCrossAxisCount(context),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final league = _leagues[index];
                return LeagueCard(league: league, onTap: () => _onLeagueTap(league));
              }, childCount: _leagues.length),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sports_basketball_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Лиги не найдены', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            'Попробуйте обновить страницу',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadLeagues();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Обновить'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }
}
