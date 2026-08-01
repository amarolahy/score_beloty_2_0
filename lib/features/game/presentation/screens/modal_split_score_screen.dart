import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/deal.dart';
import '../../domain/scoring.dart';

class ModalSplitScoreScreen extends StatefulWidget {
  const ModalSplitScoreScreen({
    super.key,
    required this.contract,
  });

  final ContractType contract;

  @override
  State<ModalSplitScoreScreen> createState() => _ModalSplitScoreScreenState();
}

class _ModalSplitScoreScreenState extends State<ModalSplitScoreScreen> {
  late final ContractSplit _split;
  late final TextEditingController _ours;
  late final TextEditingController _theirs;
  String? _error;

  int? get _oursValue => int.tryParse(_ours.text);
  int? get _theirsValue => int.tryParse(_theirs.text);

  bool get _canIncrementOurs =>
      (_oursValue ?? 0) < _split.maxPerTeam &&
      (_theirsValue ?? 0) > 0;

  bool get _canDecrementOurs =>
      (_oursValue ?? 0) > 0 &&
      (_theirsValue ?? 0) < _split.maxPerTeam;

  bool get _canIncrementTheirs =>
      (_theirsValue ?? 0) < _split.maxPerTeam &&
      (_oursValue ?? 0) > 0;

  bool get _canDecrementTheirs =>
      (_theirsValue ?? 0) > 0 &&
      (_oursValue ?? 0) < _split.maxPerTeam;

  @override
  void initState() {
    super.initState();
    _split = ContractSplit.of(widget.contract);
    _ours = TextEditingController(text: _split.defaultShare.$1.toString());
    _theirs = TextEditingController(text: _split.defaultShare.$2.toString());
    _ours.addListener(_validate);
    _theirs.addListener(_validate);
  }

  @override
  void dispose() {
    _ours.dispose();
    _theirs.dispose();
    super.dispose();
  }

  void _validate() {
    final o = _oursValue;
    final t = _theirsValue;
    final l10n = AppLocalizations.of(context);
    if (o == null || t == null) {
      setState(() => _error = l10n.invalidValues);
      return;
    }
    if (o + t != _split.total) {
      setState(() => _error =
          l10n.sumMustBeLabel(_split.total, o + t));
      return;
    }
    if (o > _split.maxPerTeam || t > _split.maxPerTeam) {
      setState(() => _error = l10n.maxPerTeamLabel(_split.maxPerTeam));
      return;
    }
    setState(() => _error = null);
  }

  void _transfer(int delta, {required bool toOurs}) {
    final o = _oursValue;
    final t = _theirsValue;
    if (o == null || t == null) return;
    final newOurs = toOurs ? o + delta : o - delta;
    final newTheirs = toOurs ? t - delta : t + delta;
    if (newOurs < 0 ||
        newOurs > _split.maxPerTeam ||
        newTheirs < 0 ||
        newTheirs > _split.maxPerTeam) {
      return;
    }
    _ours.text = newOurs.toString();
    _theirs.text = newTheirs.toString();
  }

  void _swap() {
    final tmp = _ours.text;
    _ours.text = _theirs.text;
    _theirs.text = tmp;
  }

  void _submit() {
    if (_error != null) return;
    final outcome = DealOutcome.split(_oursValue!, _theirsValue!);
    Navigator.of(context).pop(outcome);
  }

  String _contractLabel(AppLocalizations l10n) {
    switch (widget.contract) {
      case ContractType.allTrumps:
        return l10n.contractAllTrumps;
      case ContractType.noTrumps:
        return l10n.contractNoTrumps;
      case ContractType.spades:
        return l10n.contractSpades;
      case ContractType.hearts:
        return l10n.contractHearts;
      case ContractType.diamonds:
        return l10n.contractDiamonds;
      case ContractType.clubs:
        return l10n.contractClubs;
      case ContractType.error:
        return l10n.contractError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.splitTitle),
        actions: [
          IconButton(
            tooltip: l10n.invertTooltip,
            icon: const Icon(Icons.swap_horiz),
            onPressed: _swap,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.contractWithLabel(_contractLabel(l10n)),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.expectedTotalLabel(_split.total, _split.maxPerTeam),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _ScoreStepper(
                key: const ValueKey('ours-stepper'),
                label: l10n.ourScoreLabel,
                controller: _ours,
                accent: theme.colorScheme.primary,
                canDecrement: _canDecrementOurs,
                canIncrement: _canIncrementOurs,
                onDecrement: () => _transfer(1, toOurs: false),
                onIncrement: () => _transfer(1, toOurs: true),
              ),
              const SizedBox(height: 16),
              _ScoreStepper(
                key: const ValueKey('theirs-stepper'),
                label: l10n.theirScoreLabel,
                controller: _theirs,
                accent: theme.colorScheme.tertiary,
                canDecrement: _canDecrementTheirs,
                canIncrement: _canIncrementTheirs,
                onDecrement: () => _transfer(1, toOurs: true),
                onIncrement: () => _transfer(1, toOurs: false),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              FilledButton(
                onPressed: _error == null ? _submit : null,
                child: Text(l10n.validate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreStepper extends StatelessWidget {
  const _ScoreStepper({
    super.key,
    required this.label,
    required this.controller,
    required this.accent,
    required this.canDecrement,
    required this.canIncrement,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final TextEditingController controller;
  final Color accent;
  final bool canDecrement;
  final bool canIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.scoreboard_outlined, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            tooltip: '-1',
            icon: const Icon(Icons.remove_circle_outline),
            color: accent,
            onPressed: canDecrement ? onDecrement : null,
          ),
          SizedBox(
            width: 64,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          IconButton(
            tooltip: '+1',
            icon: const Icon(Icons.add_circle_outline),
            color: accent,
            onPressed: canIncrement ? onIncrement : null,
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
