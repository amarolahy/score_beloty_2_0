import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../application/game_providers.dart';
import '../../domain/game.dart';
import '../../domain/rules.dart';
import '../../domain/team.dart';

class NewGameScreen extends ConsumerStatefulWidget {
  const NewGameScreen({super.key});

  @override
  ConsumerState<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends ConsumerState<NewGameScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usP1 = TextEditingController();
  final _usP2 = TextEditingController();
  final _themP1 = TextEditingController();
  final _themP2 = TextEditingController();
  final _usScore = TextEditingController(text: '0');
  final _themScore = TextEditingController(text: '0');

  Rules _rules = const Rules();
  bool _showAdvanced = false;

  @override
  void dispose() {
    _usP1.dispose();
    _usP2.dispose();
    _themP1.dispose();
    _themP2.dispose();
    _usScore.dispose();
    _themScore.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final game = Game.fresh(
      us: Team(
        player1: _usP1.text.trim(),
        player2: _usP2.text.trim(),
        initialScore: int.tryParse(_usScore.text) ?? 0,
      ),
      them: Team(
        player1: _themP1.text.trim(),
        player2: _themP2.text.trim(),
        initialScore: int.tryParse(_themScore.text) ?? 0,
      ),
      rules: _rules,
    );
    ref.read(currentGameControllerProvider.notifier).start(game);
    context.go(AppRoutes.chooseContract);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Text('Nouvelle partie', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Saisissez les joueurs et les scores de départ.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _TeamCard(
              title: 'Notre équipe',
              accent: theme.colorScheme.primary,
              player1: _usP1,
              player2: _usP2,
              score: _usScore,
            ),
            const SizedBox(height: 16),
            _TeamCard(
              title: 'Équipe adverse',
              accent: theme.colorScheme.tertiary,
              player1: _themP1,
              player2: _themP2,
              score: _themScore,
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Règles avancées'),
                    subtitle: Text(
                      _rules == const Rules()
                          ? 'Réglages par défaut'
                          : 'Personnalisé',
                    ),
                    trailing: Icon(
                      _showAdvanced
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                    onTap: () =>
                        setState(() => _showAdvanced = !_showAdvanced),
                  ),
                  if (_showAdvanced) _RulesEditor(
                    rules: _rules,
                    onChanged: (r) => setState(() => _rules = r),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.play_arrow),
              label: const Text('COMMENCER'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({
    required this.title,
    required this.accent,
    required this.player1,
    required this.player2,
    required this.score,
  });

  final String title;
  final Color accent;
  final TextEditingController player1;
  final TextEditingController player2;
  final TextEditingController score;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 24,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: player1,
              decoration: const InputDecoration(
                labelText: 'Joueur 1',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
              validator: _required,
              inputFormatters: [LengthLimitingTextInputFormatter(32)],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: player2,
              decoration: const InputDecoration(
                labelText: 'Joueur 2',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
              validator: _required,
              inputFormatters: [LengthLimitingTextInputFormatter(32)],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: score,
              decoration: const InputDecoration(
                labelText: 'Score initial',
                prefixIcon: Icon(Icons.scoreboard_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateScore,
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Champ obligatoire';
    }
    return null;
  }

  String? _validateScore(String? value) {
    if (value == null || value.isEmpty) return 'Champ obligatoire';
    final n = int.tryParse(value);
    if (n == null || n < 0) return 'Score invalide';
    return null;
  }
}

class _RulesEditor extends StatelessWidget {
  const _RulesEditor({required this.rules, required this.onChanged});

  final Rules rules;
  final ValueChanged<Rules> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NumberField(
            label: 'Score cible',
            value: rules.finalScore,
            onChanged: (v) => onChanged(rules.copyWith(finalScore: v)),
          ),
          SwitchListTile(
            title: const Text('Partage autorisé (TA)'),
            value: rules.splitAllTrumps,
            onChanged: (v) => onChanged(rules.copyWith(splitAllTrumps: v)),
          ),
          SwitchListTile(
            title: const Text('Partage autorisé (SA)'),
            value: rules.splitNoTrumps,
            onChanged: (v) => onChanged(rules.copyWith(splitNoTrumps: v)),
          ),
          SwitchListTile(
            title: const Text('Partage autorisé (Couleur)'),
            value: rules.splitColor,
            onChanged: (v) => onChanged(rules.copyWith(splitColor: v)),
          ),
          SwitchListTile(
            title: const Text('Miara miakatra (continuer sur égalité)'),
            value: rules.continueOnTie,
            onChanged: (v) => onChanged(rules.copyWith(continueOnTie: v)),
          ),
          _NumberField(
            label: 'Palier en cas d\'égalité',
            value: rules.stepsOnTie,
            onChanged: (v) => onChanged(rules.copyWith(stepsOnTie: v)),
          ),
          SwitchListTile(
            title: const Text('Points si erreur'),
            value: rules.pointIfError,
            onChanged: (v) => onChanged(rules.copyWith(pointIfError: v)),
          ),
          _NumberField(
            label: 'Points attribués sur erreur',
            value: rules.pointOnError,
            onChanged: (v) => onChanged(rules.copyWith(pointOnError: v)),
          ),
          SwitchListTile(
            title: const Text('Gagner si capot dedans'),
            value: rules.winIfCapotInside,
            onChanged: (v) => onChanged(rules.copyWith(winIfCapotInside: v)),
          ),
          SwitchListTile(
            title: const Text('Surcontré sans atout'),
            value: rules.redoubleNoTrumps,
            onChanged: (v) => onChanged(rules.copyWith(redoubleNoTrumps: v)),
          ),
          SwitchListTile(
            title: const Text('Système de goûter activé'),
            value: rules.bet,
            onChanged: (v) => onChanged(rules.copyWith(bet: v)),
          ),
          if (rules.bet) ...[
            _NumberField(
              label: 'Mise (Ar)',
              value: rules.betAmount,
              onChanged: (v) => onChanged(rules.copyWith(betAmount: v)),
            ),
            SwitchListTile(
              title: const Text('Doubler la mise sur capot'),
              value: rules.doubleAmountOnCapotScore,
              onChanged: (v) => onChanged(
                rules.copyWith(doubleAmountOnCapotScore: v),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: value.toString(),
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) {
          final parsed = int.tryParse(text);
          if (parsed != null) onChanged(parsed);
        },
      ),
    );
  }
}
