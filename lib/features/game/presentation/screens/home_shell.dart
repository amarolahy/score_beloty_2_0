import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../settings/application/locale_providers.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  static const String logoAsset = 'assets/logos/logo.png';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      drawer: _AppDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: l10n.appTitle,
              child: Image.asset(logoAsset, height: 32),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                l10n.appTitle,
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

class _AppDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
              Image.asset(HomeShell.logoAsset, height: 56),
              const SizedBox(height: 8),
              Text(
                l10n.appTitle,
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.add_circle_outline),
          label: Text(l10n.newGame),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.history),
          label: Text(l10n.history),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.info_outline),
          label: Text(l10n.about),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 24, 16, 12),
          child: Divider(height: 1),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.language,
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              const _LanguageSelector(),
            ],
          ),
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

class _LanguageSelector extends ConsumerWidget {
  const _LanguageSelector();

  static const Map<String, Locale> _locales = {
    'FR': Locale('fr'),
    'EN': Locale('en'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentLocaleProvider);
    return SegmentedButton<Locale>(
      segments: [
        for (final entry in _locales.entries)
          ButtonSegment<Locale>(
            value: entry.value,
            label: Text(entry.key),
          ),
      ],
      selected: {current},
      onSelectionChanged: (set) {
        ref.read(localeControllerProvider.notifier).set(set.first);
      },
    );
  }
}
