import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router.dart';
import '../../application/game_providers.dart';
import '../../domain/game.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(currentGameControllerProvider);
    final theme = Theme.of(context);

    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fin de partie')),
        body: const _MissingGameView(),
      );
    }

    final winner = game.winner;
    final winnerName = winner == Winner.us
        ? '${game.us.player1} & ${game.us.player2}'
        : winner == Winner.them
            ? '${game.them.player1} & ${game.them.player2}'
            : 'Match nul';

    return Scaffold(
      appBar: AppBar(title: const Text('Fin de partie')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(
                Icons.emoji_events,
                size: 96,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Vainqueur',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                winnerName,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ScoreColumn(
                        label: '${game.us.player1} & ${game.us.player2}',
                        score: game.ourScore,
                      ),
                      const Text('—', style: TextStyle(fontSize: 28)),
                      _ScoreColumn(
                        label: '${game.them.player1} & ${game.them.player2}',
                        score: game.theirScore,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Date de la partie'),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm', 'fr_FR')
                            .format(game.createdOn),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.dealsHistory),
                icon: const Icon(Icons.list_alt),
                label: const Text('HISTORIQUE DES DONNES'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  final restarted = Game.fresh(
                    us: game.us,
                    them: game.them,
                    rules: game.rules,
                  );
                  ref
                      .read(currentGameControllerProvider.notifier)
                      .start(restarted);
                  context.go(AppRoutes.chooseContract);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('REJOUER'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(currentGameControllerProvider.notifier).clear();
                  context.go(AppRoutes.newGame);
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('NOUVELLE PARTIE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissingGameView extends StatelessWidget {
  const _MissingGameView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 56),
            const SizedBox(height: 12),
            const Text('Aucune partie terminée.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.newGame),
              child: const Text('Nouvelle partie'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$score',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
