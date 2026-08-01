import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Text(l10n.newGameTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(l10n.newGameSubtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            _TeamCard(
              title: l10n.ourTeam,
              accent: theme.colorScheme.primary,
              player1Label: l10n.player1,
              player2Label: l10n.player2,
              scoreLabel: l10n.initialScore,
              player1: _usP1,
              player2: _usP2,
              score: _usScore,
              requiredFieldLabel: l10n.requiredField,
              invalidScoreLabel: l10n.invalidScore,
            ),
            const SizedBox(height: 16),
            _TeamCard(
              title: l10n.theirTeam,
              accent: theme.colorScheme.tertiary,
              player1Label: l10n.player1,
              player2Label: l10n.player2,
              scoreLabel: l10n.initialScore,
              player1: _themP1,
              player2: _themP2,
              score: _themScore,
              requiredFieldLabel: l10n.requiredField,
              invalidScoreLabel: l10n.invalidScore,
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text(l10n.advancedRules),
                    subtitle: Text(
                      _rules == const Rules()
                          ? l10n.defaultRules
                          : l10n.customRules,
                    ),
                    trailing: Icon(
                      _showAdvanced
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                    onTap: () =>
                        setState(() => _showAdvanced = !_showAdvanced),
                  ),
                  if (_showAdvanced)
                    _RulesEditor(
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
              label: Text(l10n.startButton),
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
    required this.player1Label,
    required this.player2Label,
    required this.scoreLabel,
    required this.player1,
    required this.player2,
    required this.score,
    required this.requiredFieldLabel,
    required this.invalidScoreLabel,
  });

  final String title;
  final Color accent;
  final String player1Label;
  final String player2Label;
  final String scoreLabel;
  final TextEditingController player1;
  final TextEditingController player2;
  final TextEditingController score;
  final String requiredFieldLabel;
  final String invalidScoreLabel;

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
              decoration: InputDecoration(
                labelText: player1Label,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? requiredFieldLabel : null,
              inputFormatters: [LengthLimitingTextInputFormatter(32)],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: player2,
              decoration: InputDecoration(
                labelText: player2Label,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? requiredFieldLabel : null,
              inputFormatters: [LengthLimitingTextInputFormatter(32)],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: score,
              decoration: InputDecoration(
                labelText: scoreLabel,
                prefixIcon: const Icon(Icons.scoreboard_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) {
                if (v == null || v.isEmpty) return requiredFieldLabel;
                final n = int.tryParse(v);
                if (n == null || n < 0) return invalidScoreLabel;
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RulesEditor extends StatelessWidget {
  const _RulesEditor({required this.rules, required this.onChanged});

  final Rules rules;
  final ValueChanged<Rules> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NumberField(
            label: l10n.ruleFinalScore,
            value: rules.finalScore,
            onChanged: (v) => onChanged(rules.copyWith(finalScore: v)),
          ),
          SwitchListTile(
            title: Text(l10n.ruleSplitAllTrumps),
            value: rules.splitAllTrumps,
            onChanged: (v) => onChanged(rules.copyWith(splitAllTrumps: v)),
          ),
          SwitchListTile(
            title: Text(l10n.ruleSplitNoTrumps),
            value: rules.splitNoTrumps,
            onChanged: (v) => onChanged(rules.copyWith(splitNoTrumps: v)),
          ),
          SwitchListTile(
            title: Text(l10n.ruleSplitSuit),
            value: rules.splitSuit,
            onChanged: (v) => onChanged(rules.copyWith(splitSuit: v)),
          ),
          SwitchListTile(
            title: Text(l10n.ruleContinueOnTie),
            value: rules.continueOnTie,
            onChanged: (v) => onChanged(rules.copyWith(continueOnTie: v)),
          ),
          _NumberField(
            label: l10n.ruleStepsOnTie,
            value: rules.stepsOnTie,
            onChanged: (v) => onChanged(rules.copyWith(stepsOnTie: v)),
          ),
          SwitchListTile(
            title: Text(l10n.rulePointIfError),
            value: rules.pointIfError,
            onChanged: (v) => onChanged(rules.copyWith(pointIfError: v)),
          ),
          _NumberField(
            label: l10n.rulePointOnError,
            value: rules.pointOnError,
            onChanged: (v) => onChanged(rules.copyWith(pointOnError: v)),
          ),
          SwitchListTile(
            title: Text(l10n.ruleWinIfCapotByDefense),
            value: rules.winIfCapotByDefense,
            onChanged: (v) =>
                onChanged(rules.copyWith(winIfCapotByDefense: v)),
          ),
          SwitchListTile(
            title: Text(l10n.ruleRedoubleNoTrumps),
            value: rules.redoubleNoTrumps,
            onChanged: (v) => onChanged(rules.copyWith(redoubleNoTrumps: v)),
          ),
          SwitchListTile(
            title: Text(l10n.ruleStake),
            value: rules.stake,
            onChanged: (v) => onChanged(rules.copyWith(stake: v)),
          ),
          if (rules.stake) ...[
            _NumberField(
              label: l10n.ruleStakeAmount,
              value: rules.stakeAmount,
              onChanged: (v) => onChanged(rules.copyWith(stakeAmount: v)),
            ),
            SwitchListTile(
              title: Text(l10n.ruleStakeDoubledOnCapot),
              value: rules.stakeDoubledOnCapot,
              onChanged: (v) => onChanged(
                rules.copyWith(stakeDoubledOnCapot: v),
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
