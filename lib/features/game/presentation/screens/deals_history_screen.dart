import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/intl.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../application/game_providers.dart';
import '../../domain/deal.dart';
import '../../domain/game.dart';
import '../widgets/suit_assets.dart';

class DealsHistoryScreen extends ConsumerWidget {
  const DealsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(currentGameControllerProvider);
    final l10n = AppLocalizations.of(context);
    final empty = game == null || game.deals.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dealsHistoryTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.backTooltip,
          onPressed: () => _goBack(context, game),
        ),
      ),
      body: SafeArea(
        child: empty
            ? _EmptyState(hasGame: game != null)
            : _DealsList(deals: game.deals),
      ),
    );
  }

  void _goBack(BuildContext context, Game? game) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    if (game != null && game.isOver) {
      context.go(AppRoutes.gameOver);
    } else {
      context.go(AppRoutes.newGame);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasGame});

  final bool hasGame;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          hasGame ? l10n.noDealsRecorded : l10n.noGameInProgress,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _DealsList extends StatelessWidget {
  const _DealsList({required this.deals});

  final List<Deal> deals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: deals.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final deal = deals[index];
        return Card(
          child: ListTile(
            leading: _DealAvatar(
              contract: deal.contract,
              result: deal.result,
            ),
            title: Text(
              '${_contractLabel(l10n, deal.contract)} '
              '(${_bidLabel(l10n, deal.bid)} - ${_capotLabel(l10n, deal.capot)})',
            ),
            subtitle: Text(
              l10n.dealSubtitle(
                AppDateFormat.formatDealDate(deal.beginAt, locale),
                _resultLabel(l10n, deal.result),
                deal.ourPoints,
                deal.theirPoints,
              ),
            ),
            trailing: deal.tie
                ? Tooltip(
                    message: l10n.tieTooltip,
                    child: Icon(
                      Icons.compare_arrows,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  String _contractLabel(AppLocalizations l10n, ContractType c) {
    switch (c) {
      case ContractType.allTrumps:
        return l10n.contractShortAllTrumps;
      case ContractType.noTrumps:
        return l10n.contractShortNoTrumps;
      case ContractType.spades:
        return l10n.contractShortSpades;
      case ContractType.hearts:
        return l10n.contractShortHearts;
      case ContractType.diamonds:
        return l10n.contractShortDiamonds;
      case ContractType.clubs:
        return l10n.contractShortClubs;
      case ContractType.error:
        return l10n.contractShortError;
    }
  }

  String _bidLabel(AppLocalizations l10n, BidType b) {
    switch (b) {
      case BidType.pass:
        return l10n.bidPass;
      case BidType.double_:
        return l10n.bidDouble;
      case BidType.redouble:
        return l10n.bidRedouble;
    }
  }

  String _capotLabel(AppLocalizations l10n, CapotType c) {
    switch (c) {
      case CapotType.no:
        return l10n.capotNone;
      case CapotType.capot:
        return l10n.capotCapot;
      case CapotType.capotByDefense:
        return l10n.capotByDefense;
    }
  }

  String _resultLabel(AppLocalizations l10n, ResultType? r) {
    switch (r) {
      case ResultType.weWin:
        return l10n.resultWon;
      case ResultType.theyWin:
        return l10n.resultLost;
      case ResultType.split:
        return l10n.resultSplit;
      case ResultType.dispute:
        return l10n.resultDispute;
      case null:
        return l10n.resultPending;
    }
  }
}

class _DealAvatar extends StatelessWidget {
  const _DealAvatar({required this.contract, required this.result});

  final ContractType contract;
  final ResultType? result;

  @override
  Widget build(BuildContext context) {
    final color = _resultColor(result);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      alignment: Alignment.center,
      child: SuitIcon(contract: contract, size: 28),
    );
  }

  Color _resultColor(ResultType? r) {
    switch (r) {
      case ResultType.weWin:
        return Colors.green.shade700;
      case ResultType.theyWin:
        return Colors.red.shade700;
      case ResultType.split:
        return Colors.orange.shade700;
      case ResultType.dispute:
        return Colors.blueGrey;
      case null:
        return Colors.grey;
    }
  }
}
