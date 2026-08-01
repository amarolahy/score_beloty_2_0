import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../application/game_providers.dart';
import '../../domain/deal.dart';
import '../../domain/game.dart';
import '../../domain/scoring.dart';
import '../widgets/suit_assets.dart';

class ChooseContractScreen extends ConsumerStatefulWidget {
  const ChooseContractScreen({super.key});

  @override
  ConsumerState<ChooseContractScreen> createState() =>
      _ChooseContractScreenState();
}

class _ChooseContractScreenState extends ConsumerState<ChooseContractScreen> {
  ContractType _contract = ContractType.allTrumps;
  BidType _bid = BidType.pass;
  CapotType _capot = CapotType.no;

  static const List<ContractType> _order = [
    ContractType.allTrumps,
    ContractType.noTrumps,
    ContractType.spades,
    ContractType.hearts,
    ContractType.diamonds,
    ContractType.clubs,
  ];

  static const Map<ContractType, String> _labels = {
    ContractType.allTrumps: 'Tout atout',
    ContractType.noTrumps: 'Sans atout',
    ContractType.spades: 'Pique',
    ContractType.hearts: 'Cœur',
    ContractType.diamonds: 'Carreau',
    ContractType.clubs: 'Trèfle',
  };

  Future<void> _startDeal(Game game) async {
    final deal = Deal(
      contract: _contract,
      bid: _bid,
      capot: _capot,
      beginAt: DateTime.now(),
    );
    final next = game.addDeal(deal);
    await ref
        .read(currentGameControllerProvider.notifier)
        .replace(next)
        .persist();
    if (!mounted) return;
    context.go(AppRoutes.currentDeal);
  }

  Future<void> _cancelLast(Game game) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Annuler la dernière donne'),
        content: const Text(
          'La donne précédente sera supprimée. Continuer ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Retour'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(currentGameControllerProvider.notifier).cancelLastDeal();
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(currentGameControllerProvider);
    final theme = Theme.of(context);

    if (game == null) {
      return const _MissingGameView();
    }

    final canRedouble = !(game.rules.redoubleNoTrumps == false &&
        _contract == ContractType.noTrumps);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _ScoreBanner(game: game),
          const SizedBox(height: 24),
          Text('Contrat', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _ContractSelector(
            contracts: _order,
            labels: _labels,
            selected: _contract,
            onChanged: (c) => setState(() => _contract = c),
          ),
          const SizedBox(height: 24),
          Text('Enchère', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _BidSelector(
            selected: _bid,
            canRedouble: canRedouble,
            onChanged: (b) => setState(() => _bid = b),
          ),
          const SizedBox(height: 24),
          Text('Capot', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _CapotSelector(
            selected: _capot,
            onChanged: (c) => setState(() => _capot = c),
          ),
          const SizedBox(height: 24),
          _ScorePreview(
            contract: _contract,
            bid: _bid,
            capot: _capot,
            rules: game.rules,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _contract == ContractType.error
                ? null
                : () => _startDeal(game),
            icon: const Icon(Icons.play_arrow),
            label: const Text('COMMENCER LA DONNE'),
          ),
          if (game.deals.isNotEmpty) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _cancelLast(game),
              icon: const Icon(Icons.undo),
              label: const Text('Annuler la dernière donne'),
            ),
          ],
        ],
      ),
    );
  }
}

class _MissingGameView extends StatelessWidget {
  const _MissingGameView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 56),
            const SizedBox(height: 12),
            const Text('Aucune partie en cours'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.newGame),
              child: const Text('Nouvelle partie'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreBanner extends StatelessWidget {
  const _ScoreBanner({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Text(
              '${game.us.player1} & ${game.us.player2}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              '${game.ourScore}',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Divider(),
            Text(
              '${game.theirScore}',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${game.them.player1} & ${game.them.player2}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Cible: ${game.effectiveFinalScoreValue}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContractSelector extends StatelessWidget {
  const _ContractSelector({
    required this.contracts,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<ContractType> contracts;
  final Map<ContractType, String> labels;
  final ContractType selected;
  final ValueChanged<ContractType> onChanged;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        for (final type in contracts)
          _ContractTile(
            label: labels[type] ?? '',
            contract: type,
            isSelected: selected == type,
            onTap: () => onChanged(type),
          ),
      ],
    );
  }
}

class _ContractTile extends StatelessWidget {
  const _ContractTile({
    required this.label,
    required this.contract,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final ContractType contract;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isSelected ? scheme.primaryContainer : scheme.surfaceContainerHighest;
    final fg = isSelected ? scheme.onPrimaryContainer : scheme.onSurface;
    final suit = SuitAssets.forContract(contract);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                suit.assetPath,
                width: 36,
                height: 36,
                colorFilter: ColorFilter.mode(suit.color, BlendMode.srcIn),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BidSelector extends StatelessWidget {
  const _BidSelector({
    required this.selected,
    required this.canRedouble,
    required this.onChanged,
  });

  final BidType selected;
  final bool canRedouble;
  final ValueChanged<BidType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<BidType>(
      segments: [
        ButtonSegment(value: BidType.pass, label: const Text('Passe')),
        ButtonSegment(value: BidType.double_, label: const Text('Contré')),
        ButtonSegment(
          value: BidType.redouble,
          label: const Text('Surcontré'),
          enabled: canRedouble,
        ),
      ],
      selected: {selected},
      onSelectionChanged: (set) => onChanged(set.first),
    );
  }
}

class _CapotSelector extends StatelessWidget {
  const _CapotSelector({required this.selected, required this.onChanged});

  final CapotType selected;
  final ValueChanged<CapotType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<CapotType>(
      segments: const [
        ButtonSegment(value: CapotType.no, label: Text('Aucun')),
        ButtonSegment(value: CapotType.capot, label: Text('Capot')),
        ButtonSegment(value: CapotType.capotInside, label: Text('Dedans')),
      ],
      selected: {selected},
      onSelectionChanged: (set) => onChanged(set.first),
    );
  }
}

class _ScorePreview extends StatelessWidget {
  const _ScorePreview({
    required this.contract,
    required this.bid,
    required this.capot,
    required this.rules,
  });

  final ContractType contract;
  final BidType bid;
  final CapotType capot;
  final dynamic rules;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = ScoringEngine.computeTotal(
      contract: contract,
      bid: bid,
      capot: capot,
      rules: rules,
    );
    final splitAllowed = ScoringEngine.isSplitAllowed(contract, rules);
    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.calculate_outlined,
              color: theme.colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mise calculée',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    '$total points',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (splitAllowed)
                    Text(
                      'Partage autorisé',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
