import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/game_providers.dart';

class GamesHistoryScreen extends ConsumerWidget {
  const GamesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesHistoryControllerProvider);
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: games.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return _EmptyState(
              icon: Icons.casino_outlined,
              title: l10n.emptyGames,
              subtitle: l10n.emptyGamesSubtitle,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final game = list[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.casino),
                  title: Text(
                    '${game.us.player1} & ${game.us.player2} '
                    'vs ${game.them.player1} & ${game.them.player2}',
                  ),
                  subtitle: Text(l10n.gameSummary(
                    game.ourScore,
                    game.theirScore,
                    game.deals.length,
                  )),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref
                        .read(gamesHistoryControllerProvider.notifier)
                        .remove(game),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pushReplacementNamed(
                AppRoutes.newGame,
              ),
              icon: const Icon(Icons.add_circle_outline),
              label: Text(AppLocalizations.of(context).newGame),
            ),
          ],
        ),
      ),
    );
  }
}
