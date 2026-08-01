import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/intl.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/game_providers.dart';

class GameInfoScreen extends ConsumerWidget {
  const GameInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(currentGameControllerProvider);
    final l10n = AppLocalizations.of(context);
    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.infoTitle)),
        body: Center(child: Text(l10n.noGameInProgress)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.infoTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _InfoTile(
              label: l10n.startTime,
              value: AppDateFormat.formatGameDate(
                game.createdOn,
                Localizations.localeOf(context),
              ),
            ),
            _InfoTile(label: l10n.dealsCountLabel, value: l10n.dealsCount(game.deals.length)),
            _InfoTile(
              label: l10n.ourTeamInfo,
              value: '${game.us.player1} & ${game.us.player2}',
            ),
            _InfoTile(
              label: l10n.theirTeamInfo,
              value: '${game.them.player1} & ${game.them.player2}',
            ),
            _InfoTile(
              label: l10n.ourInitialScore,
              value: '${game.us.initialScore}',
            ),
            _InfoTile(
              label: l10n.theirInitialScore,
              value: '${game.them.initialScore}',
            ),
            _InfoTile(label: l10n.targetScore, value: '${game.rules.finalScore}'),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                l10n.activeRules,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            _InfoTile(
              label: l10n.ruleSplitAllTrumps,
              value: game.rules.splitAllTrumps ? l10n.yesLabel : l10n.noLabel,
            ),
            _InfoTile(
              label: l10n.ruleSplitNoTrumps,
              value: game.rules.splitNoTrumps ? l10n.yesLabel : l10n.noLabel,
            ),
            _InfoTile(
              label: l10n.ruleSplitSuit,
              value: game.rules.splitSuit ? l10n.yesLabel : l10n.noLabel,
            ),
            _InfoTile(
              label: l10n.ruleContinueOnTie,
              value: game.rules.continueOnTie ? l10n.yesLabel : l10n.noLabel,
            ),
            _InfoTile(
              label: l10n.ruleStake,
              value: game.rules.stake
                  ? l10n.stakeAmountLabel(game.rules.stakeAmount)
                  : l10n.noLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(label),
      trailing: Text(value),
    );
  }
}
