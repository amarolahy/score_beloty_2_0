import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/intl.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/game_providers.dart';
import '../../domain/game.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(currentGameControllerProvider);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.gameOverTitle)),
        body: const _MissingGameView(),
      );
    }

    final winner = game.winner;
    final winnerName = winner == Winner.us
        ? '${game.us.player1} & ${game.us.player2}'
        : winner == Winner.them
            ? '${game.them.player1} & ${game.them.player2}'
            : l10n.draw;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.gameOverTitle)),
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
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.winner,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                winnerName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                      Text(l10n.gameDate),
                      Text(
                        AppDateFormat.formatLongDate(game.createdOn, locale),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.dealsHistory),
                icon: const Icon(Icons.list_alt),
                label: Text(l10n.historyButton),
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
                label: Text(l10n.replayButton),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(currentGameControllerProvider.notifier).clear();
                  context.go(AppRoutes.newGame);
                },
                icon: const Icon(Icons.add_circle_outline),
                label: Text(l10n.newGameButton),
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
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 56),
            const SizedBox(height: 12),
            Text(l10n.noFinishedGame),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.newGame),
              child: Text(l10n.newGame),
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
