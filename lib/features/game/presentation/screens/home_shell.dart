import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _AppDrawer(),
      appBar: AppBar(
        title: const Text('Score Beloty'),
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
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(28, 24, 28, 12),
          child: Text(
            'Score Beloty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.add_circle_outline),
          label: Text('Nouvelle partie'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.history),
          label: Text('Historique'),
        ),
        NavigationDrawerDestination(
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
