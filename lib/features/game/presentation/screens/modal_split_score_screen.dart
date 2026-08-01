import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/deal.dart';
import '../../domain/rules.dart';
import '../../domain/scoring.dart';

class ModalSplitScoreScreen extends StatefulWidget {
  const ModalSplitScoreScreen({
    super.key,
    required this.contract,
    required this.rules,
  });

  final ContractType contract;
  final Rules rules;

  @override
  State<ModalSplitScoreScreen> createState() => _ModalSplitScoreScreenState();
}

class _ModalSplitScoreScreenState extends State<ModalSplitScoreScreen> {
  late final TextEditingController _ours;
  late final TextEditingController _theirs;
  String? _error;

  int get _maxSplit {
    switch (widget.contract) {
      case ContractType.allTrumps:
        return 18;
      case ContractType.noTrumps:
        return 35;
      case ContractType.error:
        return 0;
      default:
        return 11;
    }
  }

  int get _expectedTotal {
    switch (widget.contract) {
      case ContractType.allTrumps:
        return 26;
      case ContractType.noTrumps:
        return 52;
      default:
        return 16;
    }
  }

  int? get _oursValue => int.tryParse(_ours.text);
  int? get _theirsValue => int.tryParse(_theirs.text);

  @override
  void initState() {
    super.initState();
    final defaults = _defaultsFor(widget.contract);
    _ours = TextEditingController(text: defaults.$1.toString());
    _theirs = TextEditingController(text: defaults.$2.toString());
    _ours.addListener(_validate);
    _theirs.addListener(_validate);
  }

  @override
  void dispose() {
    _ours.dispose();
    _theirs.dispose();
    super.dispose();
  }

  (int, int) _defaultsFor(ContractType contract) {
    switch (contract) {
      case ContractType.allTrumps:
        return (14, 12);
      case ContractType.noTrumps:
        return (27, 25);
      case ContractType.error:
        return (0, 0);
      default:
        return (9, 7);
    }
  }

  void _validate() {
    final o = _oursValue;
    final t = _theirsValue;
    if (o == null || t == null) {
      setState(() => _error = 'Valeurs invalides');
      return;
    }
    if (o + t != _expectedTotal) {
      setState(() => _error =
          'La somme doit valoir $_expectedTotal (saisie: ${o + t})');
      return;
    }
    if (o > _maxSplit || t > _maxSplit) {
      setState(() => _error =
          'Maximum par équipe : $_maxSplit points');
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partage'),
        actions: [
          IconButton(
            tooltip: 'Inverser',
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
                'Contrat : ${_contractLabel(widget.contract)}',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Somme attendue : $_expectedTotal • Maximum par équipe : $_maxSplit',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _SplitField(
                controller: _ours,
                label: 'Notre score',
                accent: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              _SplitField(
                controller: _theirs,
                label: 'Leur score',
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
                child: const Text('VALIDER'),
              ),
            ],
          ),
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
