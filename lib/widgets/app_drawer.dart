import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                    onTap: () => context.go('/'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.emoji_events_outlined,
                    title: 'Все лиги',
                    onTap: () {
                      context.go('/');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.account_tree_outlined,
                    title: 'Все турниры',
                    onTap: () {
                      context.pop();
                      context.push('/tournaments');
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.sports_basketball_outlined,
                    title: 'Последние игры',
                    onTap: () {
                      context.pop();
                      context.push('/games?recent=true');
                    },
                  ),
                  const Divider(height: 1),
                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'О приложении',
                    onTap: () {
                      context.pop();
                      context.push('/about');
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
}
