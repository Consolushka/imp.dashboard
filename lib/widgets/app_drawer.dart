import 'package:flutter/material.dart';
import '../screens/games_screen.dart';
import '../screens/tournaments_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IMP',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Basketball Stats',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Навигационные элементы
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_outlined,
                    title: 'Главная',
                    onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.emoji_events_outlined,
                    title: 'Все лиги',
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.account_circle,
                    title: 'Все турниры',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TournamentsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.sports_basketball_outlined,
                    title: 'Последние игры',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const GamesScreen(isRecentGames: true),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'О приложении',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 4,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('О приложении IMP'),
        content: const Text(
          'Приложение для просмотра баскетбольной статистики.\n'
              'Версия 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Закрыть',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
