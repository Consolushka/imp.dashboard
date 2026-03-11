import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart' show usePathUrlStrategy;
import 'package:imp/core/di.dart';
import 'package:imp/screens/about_screen.dart';
import 'package:imp/screens/game_details_screen.dart';
import 'package:imp/screens/games_screen.dart';
import 'package:imp/screens/home_screen.dart';
import 'package:imp/screens/leaderboard_screen.dart';
import 'package:imp/screens/tournaments_screen.dart';
import 'package:imp/models/league_model.dart';
import 'package:imp/models/tournament_model.dart';
import 'package:imp/models/game_model.dart';

const apiUrl = "https://hfhq-a10d-zqqo.gw-1a.dockhost.net/api";
// const apiUrl = "http://localhost/api";

void main() {
  // Включаем чистые URL (без #)
  usePathUrlStrategy();
  
  DependencyInjection().registerDependencies();
  runApp(ImpApp());
}

class ImpApp extends StatelessWidget {
  ImpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IMP Basketball Stats',
      theme: _buildTheme(),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/tournaments',
        builder: (context, state) {
          final league = state.extra as League?;
          return TournamentsScreen(league: league);
        },
      ),
      GoRoute(
        path: '/games',
        builder: (context, state) {
          final tournament = state.extra as Tournament?;
          final isRecentGames = state.uri.queryParameters['recent'] == 'true';
          return GamesScreen(tournament: tournament, isRecentGames: isRecentGames);
        },
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) {
          final tournament = state.extra as Tournament?;
          return LeaderboardScreen(tournament: tournament);
        },
      ),
      GoRoute(
        path: '/game/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final game = state.extra as Game?;
          return GameDetailScreen(game: game, gameId: id);
        },
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutImpScreen(),
      ),
    ],
  );

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.grey,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        outline: Colors.grey,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      dividerColor: Colors.grey,
    );
  }
}
