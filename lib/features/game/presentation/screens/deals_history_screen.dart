import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/game_providers.dart';
import '../../domain/deal.dart';

class DealsHistoryScreen extends ConsumerWidget {
  const DealsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(currentGameControllerProvider);
    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Historique des donnes')),
        body: const Center(child: Text('Aucune partie en cours.')),
      );
    }
    if (game.deals.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Historique des donnes')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Aucune donne enregistrée pour cette partie.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final dateFormat = DateFormat('EEE dd/MM HH:mm', 'fr_FR');
    return Scaffold(
      appBar: AppBar(title: const Text('Historique des donnes')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: game.deals.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final deal = game.deals[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      _resultColor(deal.result).withValues(alpha: 0.15),
                  child: Icon(
                    _resultIcon(deal.result),
                    color: _resultColor(deal.result),
                  ),
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
              ),
            );
          },
        ),
      ),
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

  IconData _resultIcon(ResultType? r) {
    switch (r) {
      case ResultType.weWin:
        return Icons.emoji_events;
      case ResultType.theyWin:
        return Icons.cancel;
      case ResultType.split:
        return Icons.handshake;
      case ResultType.litigation:
        return Icons.gavel;
      case null:
        return Icons.hourglass_empty;
    }
  }

  Color _resultColor(ResultType? r) {
    switch (r) {
      case ResultType.weWin:
        return Colors.green;
      case ResultType.theyWin:
        return Colors.red;
      case ResultType.split:
        return Colors.orange;
      case ResultType.litigation:
        return Colors.blueGrey;
      case null:
        return Colors.grey;
    }
  }
}
