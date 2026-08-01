import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  static const String logoAsset = 'assets/logos/logo.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _AppDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: 'Logo Score Beloty',
              child: Image.asset(logoAsset, height: 32),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Score Beloty',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final theme = Theme.of(context);
    return NavigationDrawer(
      selectedIndex: _indexFor(location),
      onDestinationSelected: (index) {
        Navigator.of(context).pop();
        switch (index) {
          case 0:
            context.go(AppRoutes.newGame);
          case 1:
            context.go(AppRoutes.gamesHistory);
          case 2:
            context.go(AppRoutes.about);
        }
      },
      children: [
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                HomeShell.logoAsset,
                height: 56,
              ),
              const SizedBox(height: 8),
              Text(
                'Score Beloty',
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.add_circle_outline),
          label: Text('Nouvelle partie'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.history),
          label: Text('Historique'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.info_outline),
          label: Text('À propos'),
        ),
      ],
    );
  }

  int _indexFor(String location) {
    if (location.startsWith(AppRoutes.gamesHistory)) return 1;
    if (location.startsWith(AppRoutes.about)) return 2;
    return 0;
  }
}
