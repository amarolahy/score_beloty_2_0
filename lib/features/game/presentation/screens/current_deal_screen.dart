import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../application/game_providers.dart';
import '../../domain/deal.dart';
import '../../domain/game.dart';
import '../../domain/scoring.dart';
import 'modal_split_score_screen.dart';

class CurrentDealScreen extends ConsumerWidget {
  const CurrentDealScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(currentGameControllerProvider);

    if (game == null) {
      return const _MissingGameView();
    }
    final deal = game.currentDeal;
    if (deal == null || deal.isFinished) {
      return const _MissingDealView();
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _DealHeader(game: game, deal: deal),
          const SizedBox(height: 24),
          Text(
            'Résultat de la donne',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _OutcomeActions(game: game, deal: deal),
        ],
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
            const Text('Aucune partie en cours'),
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

class _MissingDealView extends StatelessWidget {
  const _MissingDealView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.style_outlined, size: 56),
            const SizedBox(height: 12),
            const Text(
              'Aucune donne en cours. Démarrez-en une nouvelle.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.chooseContract),
              child: const Text('Choisir un contrat'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DealHeader extends StatelessWidget {
  const _DealHeader({required this.game, required this.deal});

  final Game game;
  final Deal deal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final total = ScoringEngine.computeTotal(
      contract: deal.contract,
      bid: deal.bid,
      capot: deal.capot,
      rules: game.rules,
    );

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _contractLabel(deal.contract),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_bidLabel(deal.bid)} • ${_capotLabel(deal.capot)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ScoreColumn(
                  label: '${game.us.player1} & ${game.us.player2}',
                  score: game.ourScore,
                  scheme: scheme,
                ),
                Text(
                  '$total pts',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                _ScoreColumn(
                  label: '${game.them.player1} & ${game.them.player2}',
                  score: game.theirScore,
                  scheme: scheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _contractLabel(ContractType c) {
    switch (c) {
      case ContractType.allTrumps:
        return 'Tout atout';
      case ContractType.noTrumps:
        return 'Sans atout';
      case ContractType.spades:
        return 'Pique';
      case ContractType.hearts:
        return 'Cœur';
      case ContractType.diamonds:
        return 'Carreau';
      case ContractType.clubs:
        return 'Trèfle';
      case ContractType.error:
        return 'Erreur';
    }
  }

  String _bidLabel(BidType b) {
    switch (b) {
      case BidType.pass:
        return 'Passe';
      case BidType.double_:
        return 'Contré';
      case BidType.redouble:
        return 'Surcontré';
    }
  }

  String _capotLabel(CapotType c) {
    switch (c) {
      case CapotType.no:
        return 'Aucun capot';
      case CapotType.capot:
        return 'Capot';
      case CapotType.capotInside:
        return 'Capot dedans';
    }
  }
}

class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn({
    required this.label,
    required this.score,
    required this.scheme,
  });

  final String label;
  final int score;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$score',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: scheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: scheme.onPrimaryContainer,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _OutcomeActions extends ConsumerWidget {
  const _OutcomeActions({required this.game, required this.deal});

  final Game game;
  final Deal deal;

  Future<void> _applyOutcome(
    BuildContext context,
    WidgetRef ref,
    DealOutcome outcome,
  ) async {
    final finished = outcome.toDeal(
      beginAt: deal.beginAt,
      contract: deal.contract,
      bid: deal.bid,
      capot: deal.capot,
    );
    final updatedDeals = [
      ...game.deals.sublist(0, game.deals.length - 1),
      finished,
    ];
    var next = game.copyWith(deals: updatedDeals);
    next = next.continueCauseTie();
    next = next.markFinishedIfNeeded();
    await ref
        .read(currentGameControllerProvider.notifier)
        .replace(next)
        .persist();
    if (!context.mounted) return;
    if (next.isOver) {
      context.go(AppRoutes.gameOver);
    } else {
      context.go(AppRoutes.chooseContract);
    }
  }

  Future<void> _openSplit(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.of(context).push<DealOutcome?>(
      MaterialPageRoute(
        builder: (_) => ModalSplitScoreScreen(
          contract: deal.contract,
          rules: game.rules,
        ),
        fullscreenDialog: true,
      ),
    );
    if (result != null && context.mounted) {
      await _applyOutcome(context, ref, result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ScoringEngine.computeTotal(
      contract: deal.contract,
      bid: deal.bid,
      capot: deal.capot,
      rules: game.rules,
    );
    final splitAllowed =
        ScoringEngine.isSplitAllowed(deal.contract, game.rules);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OutcomeButton(
          icon: Icons.emoji_events,
          label: 'On a gagné',
          subtitle: '+$total points',
          color: Colors.green,
          onTap: () => _applyOutcome(
            context,
            ref,
            DealOutcome.usWin(total),
          ),
        ),
        const SizedBox(height: 12),
        _OutcomeButton(
          icon: Icons.cancel,
          label: 'Ils ont gagné',
          subtitle: '+$total points pour eux',
          color: Colors.red,
          onTap: () => _applyOutcome(
            context,
            ref,
            DealOutcome.themWin(total),
          ),
        ),
        if (splitAllowed) ...[
          const SizedBox(height: 12),
          _OutcomeButton(
            icon: Icons.handshake,
            label: 'Partage',
            subtitle: 'Saisir les scores manuellement',
            color: Colors.orange,
            onTap: () => _openSplit(context, ref),
          ),
        ],
        const SizedBox(height: 12),
        _OutcomeButton(
          icon: Icons.gavel,
          label: 'Litige',
          subtitle: 'Chaque camp conserve ses points',
          color: Colors.blueGrey,
          onTap: () => _applyOutcome(
            context,
            ref,
            DealOutcome.litigation(game.ourScore, game.theirScore),
          ),
        ),
      ],
    );
  }
}

class _OutcomeButton extends StatelessWidget {
  const _OutcomeButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(label),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
