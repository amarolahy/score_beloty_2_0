import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router.dart';
import '../../application/game_providers.dart';
import '../../domain/deal.dart';
import '../../domain/game.dart';
import '../widgets/suit_assets.dart';

class DealsHistoryScreen extends ConsumerWidget {
  const DealsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(currentGameControllerProvider);
    final empty = game == null || game.deals.isEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des donnes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          hasGame
              ? 'Aucune donne enregistrée pour cette partie.'
              : 'Aucune partie en cours.',
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
    final dateFormat = DateFormat('EEE dd/MM HH:mm', 'fr_FR');
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
              '${_contractLabel(deal.contract)} '
              '(${_bidLabel(deal.bid)} - ${_capotLabel(deal.capot)})',
            ),
            subtitle: Text(
              '${dateFormat.format(deal.beginAt)} • '
              '${_resultLabel(deal.result)} • '
              '${deal.ourPoints} - ${deal.theirPoints}',
            ),
            trailing: deal.tie
                ? Tooltip(
                    message: 'Égalité appliquée (miara miakatra)',
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

  String _contractLabel(ContractType c) {
    switch (c) {
      case ContractType.allTrumps:
        return 'TA';
      case ContractType.noTrumps:
        return 'SA';
      case ContractType.spades:
        return 'Pique';
      case ContractType.hearts:
        return 'Cœur';
      case ContractType.diamonds:
        return 'Carreau';
      case ContractType.clubs:
        return 'Trèfle';
      case ContractType.error:
        return '—';
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
        return 'Aucun';
      case CapotType.capot:
        return 'Capot';
      case CapotType.capotInside:
        return 'Dedans';
    }
  }

  String _resultLabel(ResultType? r) {
    switch (r) {
      case ResultType.weWin:
        return 'On a gagné';
      case ResultType.theyWin:
        return 'Ils ont gagné';
      case ResultType.split:
        return 'Partage';
      case ResultType.litigation:
        return 'Litige';
      case null:
        return 'En cours';
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
      case ResultType.litigation:
        return Colors.blueGrey;
      case null:
        return Colors.grey;
    }
  }
}
