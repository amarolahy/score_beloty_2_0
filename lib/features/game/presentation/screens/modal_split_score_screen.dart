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
              _SplitField(
                controller: _ours,
                label: l10n.ourScoreLabel,
                accent: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              _SplitField(
                controller: _theirs,
                label: l10n.theirScoreLabel,
                accent: theme.colorScheme.tertiary,
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

class _SplitField extends StatelessWidget {
  const _SplitField({
    required this.controller,
    required this.label,
    required this.accent,
  });

  final TextEditingController controller;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.scoreboard_outlined, color: accent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
