import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../l10n/generated/app_localizations.dart';
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

  static const List<ContractType> _trumpsOrder = [
    ContractType.allTrumps,
    ContractType.noTrumps,
  ];

  static const List<ContractType> _suitsOrder = [
    ContractType.spades,
    ContractType.hearts,
    ContractType.diamonds,
    ContractType.clubs,
  ];

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
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cancelLastDealDialogTitle),
        content: Text(l10n.cancelLastDealDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.backAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.cancelAction),
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
    final l10n = AppLocalizations.of(context);

    if (game == null) {
      return _MissingGameView();
    }

    final canRedouble = !(game.rules.redoubleNoTrumps == false &&
        _contract == ContractType.noTrumps);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _ScoreBanner(game: game),
          const SizedBox(height: 24),
          Text(l10n.contractLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _ContractSelector(
            contracts: _trumpsOrder,
            labels: _contractLabels(l10n),
            selected: _contract,
            crossAxisCount: 2,
            childAspectRatio: 2,
            onChanged: (c) => setState(() => _contract = c),
          ),
          const SizedBox(height: 12),
          _ContractSelector(
            contracts: _suitsOrder,
            labels: _contractLabels(l10n),
            selected: _contract,
            crossAxisCount: 4,
            childAspectRatio: 0.85,
            onChanged: (c) => setState(() => _contract = c),
          ),
          const SizedBox(height: 24),
          Text(l10n.bidLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _BidSelector(
            selected: _bid,
            canRedouble: canRedouble,
            labels: _bidLabels(l10n),
            onChanged: (b) => setState(() => _bid = b),
          ),
          const SizedBox(height: 24),
          Text(l10n.capotLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _CapotSelector(
            selected: _capot,
            labels: _capotLabels(l10n),
            onChanged: (c) => setState(() => _capot = c),
          ),
          const SizedBox(height: 24),
          _ScorePreview(
            contract: _contract,
            bid: _bid,
            capot: _capot,
            rules: game.rules,
            calculatedStakeLabel: l10n.calculatedStake,
            splitAllowedLabel: l10n.splitAllowed,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _contract == ContractType.error
                ? null
                : () => _startDeal(game),
            icon: const Icon(Icons.play_arrow),
            label: Text(l10n.startDealButton),
          ),
          if (game.deals.isNotEmpty) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _cancelLast(game),
              icon: const Icon(Icons.undo),
              label: Text(l10n.cancelLastDealButton),
            ),
          ],
        ],
      ),
    );
  }

  Map<ContractType, String> _contractLabels(AppLocalizations l10n) => {
        ContractType.allTrumps: l10n.contractAllTrumps,
        ContractType.noTrumps: l10n.contractNoTrumps,
        ContractType.spades: l10n.contractSpades,
        ContractType.hearts: l10n.contractHearts,
        ContractType.diamonds: l10n.contractDiamonds,
        ContractType.clubs: l10n.contractClubs,
      };

  Map<BidType, String> _bidLabels(AppLocalizations l10n) => {
        BidType.pass: l10n.bidPass,
        BidType.double_: l10n.bidDouble,
        BidType.redouble: l10n.bidRedouble,
      };

  Map<CapotType, String> _capotLabels(AppLocalizations l10n) => {
        CapotType.no: l10n.capotNone,
        CapotType.capot: l10n.capotCapot,
        CapotType.capotByDefense: l10n.capotByDefense,
      };
}

class _MissingGameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 56),
            const SizedBox(height: 12),
            Text(l10n.noCurrentGame),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.newGame),
              child: Text(l10n.newGame),
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
    final l10n = AppLocalizations.of(context);
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
                l10n.target(game.targetScore),
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
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.onChanged,
  });

  final List<ContractType> contracts;
  final Map<ContractType, String> labels;
  final ContractType selected;
  final int crossAxisCount;
  final double childAspectRatio;
  final ValueChanged<ContractType> onChanged;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: childAspectRatio,
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
    required this.labels,
    required this.onChanged,
  });

  final BidType selected;
  final bool canRedouble;
  final Map<BidType, String> labels;
  final ValueChanged<BidType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<BidType>(
      segments: [
        ButtonSegment(value: BidType.pass, label: Text(labels[BidType.pass]!)),
        ButtonSegment(
          value: BidType.double_,
          label: Text(labels[BidType.double_]!),
        ),
        ButtonSegment(
          value: BidType.redouble,
          label: Text(labels[BidType.redouble]!),
          enabled: canRedouble,
        ),
      ],
      selected: {selected},
      onSelectionChanged: (set) => onChanged(set.first),
    );
  }
}

class _CapotSelector extends StatelessWidget {
  const _CapotSelector({
    required this.selected,
    required this.labels,
    required this.onChanged,
  });

  final CapotType selected;
  final Map<CapotType, String> labels;
  final ValueChanged<CapotType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<CapotType>(
      segments: [
        ButtonSegment(value: CapotType.no, label: Text(labels[CapotType.no]!)),
        ButtonSegment(
          value: CapotType.capot,
          label: Text(labels[CapotType.capot]!),
        ),
        ButtonSegment(
          value: CapotType.capotByDefense,
          label: Text(labels[CapotType.capotByDefense]!),
        ),
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
    required this.calculatedStakeLabel,
    required this.splitAllowedLabel,
  });

  final ContractType contract;
  final BidType bid;
  final CapotType capot;
  final dynamic rules;
  final String calculatedStakeLabel;
  final String splitAllowedLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
                    calculatedStakeLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    l10n.pointsUnit(total),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (splitAllowed)
                    Text(
                      splitAllowedLabel,
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
