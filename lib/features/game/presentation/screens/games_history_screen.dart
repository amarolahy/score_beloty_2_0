import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/game_providers.dart';

class GamesHistoryScreen extends ConsumerWidget {
  const GamesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesHistoryControllerProvider);
    return SafeArea(
      child: games.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const _EmptyState(
              icon: Icons.casino_outlined,
              title: 'Aucune partie',
              subtitle: 'Démarrez une nouvelle partie pour la voir ici.',
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
                  subtitle: Text(
                    'Score ${game.ourScore} - ${game.theirScore} • '
                    '${game.deals.length} donnes',
                  ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
