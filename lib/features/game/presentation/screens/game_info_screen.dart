import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/game_providers.dart';

class GameInfoScreen extends ConsumerWidget {
  const GameInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(currentGameControllerProvider);
    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Informations')),
        body: const Center(child: Text('Aucune partie en cours.')),
      );
    }
    final dateFormat = DateFormat('EEE dd/MM/yy HH:mm', 'fr_FR');
    return Scaffold(
      appBar: AppBar(title: const Text('Informations')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _InfoTile(label: 'Début', value: dateFormat.format(game.createdOn)),
            _InfoTile(label: 'Donnes', value: game.deals.length.toString()),
            _InfoTile(
              label: 'Notre équipe',
              value: '${game.us.player1} & ${game.us.player2}',
            ),
            _InfoTile(
              label: 'Équipe adverse',
              value: '${game.them.player1} & ${game.them.player2}',
            ),
            _InfoTile(
              label: 'Score initial (nous)',
              value: '${game.us.initialScore}',
            ),
            _InfoTile(
              label: 'Score initial (eux)',
              value: '${game.them.initialScore}',
            ),
            _InfoTile(label: 'Score cible', value: '${game.rules.finalScore}'),
            const Divider(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Règles actives',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            _InfoTile(
              label: 'Partage autorisé (TA)',
              value: game.rules.splitAllTrumps ? 'Oui' : 'Non',
            ),
            _InfoTile(
              label: 'Partage autorisé (SA)',
              value: game.rules.splitNoTrumps ? 'Oui' : 'Non',
            ),
            _InfoTile(
              label: 'Partage autorisé (Couleur)',
              value: game.rules.splitColor ? 'Oui' : 'Non',
            ),
            _InfoTile(
              label: 'Miara miakatra',
              value: game.rules.continueOnTie ? 'Oui' : 'Non',
            ),
            _InfoTile(
              label: 'Système de goûter',
              value: game.rules.bet
                  ? 'Oui (${game.rules.betAmount} Ar)'
                  : 'Non',
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
