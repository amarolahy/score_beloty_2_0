import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:score_beloty_2_0/features/game/application/game_providers.dart';
import 'package:score_beloty_2_0/features/game/domain/deal.dart';
import 'package:score_beloty_2_0/features/game/domain/game.dart';
import 'package:score_beloty_2_0/features/game/domain/rules.dart';
import 'package:score_beloty_2_0/features/game/domain/team.dart';
import 'package:score_beloty_2_0/features/game/presentation/screens/deals_history_screen.dart';
import 'package:score_beloty_2_0/features/game/presentation/widgets/suit_assets.dart';

Game _gameWithDeals(List<Deal> deals) {
  return Game.fresh(
    us: const Team(player1: 'A', player2: 'B'),
    them: const Team(player1: 'C', player2: 'D'),
    rules: const Rules(),
    deals: deals,
  );
}

Deal _deal({
  required ContractType contract,
  required ResultType result,
  required int ours,
  required int theirs,
  bool tie = false,
}) {
  return Deal(
    contract: contract,
    bid: BidType.pass,
    beginAt: DateTime(2026, 6, 1, 10),
    result: result,
    ourPoints: ours,
    theirPoints: theirs,
    tie: tie,
  );
}

class _SeededScreen extends ConsumerStatefulWidget {
  const _SeededScreen({required this.game});

  final Game game;

  @override
  ConsumerState<_SeededScreen> createState() => _SeededScreenState();
}

class _SeededScreenState extends ConsumerState<_SeededScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      ref.read(currentGameControllerProvider.notifier).start(widget.game);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DealsHistoryScreen());
  }
}

Widget _wrap(Game game) {
  return ProviderScope(
    child: _SeededScreen(game: game),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('renders an empty state when there are no deals',
      (tester) async {
    final game = _gameWithDeals(const <Deal>[]);
    await tester.pumpWidget(_wrap(game));
    await tester.pumpAndSettle();

    expect(find.text('Aucune donne enregistrée pour cette partie.'),
        findsOneWidget);
  });

  testWidgets('renders one deal tile per deal with a suit avatar',
      (tester) async {
    final game = _gameWithDeals([
      _deal(
        contract: ContractType.spades,
        result: ResultType.weWin,
        ours: 162,
        theirs: 0,
      ),
      _deal(
        contract: ContractType.hearts,
        result: ResultType.theyWin,
        ours: 0,
        theirs: 26,
      ),
      _deal(
        contract: ContractType.allTrumps,
        result: ResultType.split,
        ours: 14,
        theirs: 12,
        tie: true,
      ),
    ]);

    await tester.binding.setSurfaceSize(const Size(600, 1400));
    await tester.pumpWidget(_wrap(game));
    await tester.pumpAndSettle();

    // Three suit avatars
    expect(find.byType(SuitIcon), findsNWidgets(3));

    // Three deal titles with contract labels
    expect(find.textContaining('Pique'), findsOneWidget);
    expect(find.textContaining('Cœur'), findsOneWidget);
    expect(find.textContaining('TA'), findsOneWidget);

    // Three result labels
    expect(find.textContaining('On a gagné'), findsOneWidget);
    expect(find.textContaining('Ils ont gagné'), findsOneWidget);
    expect(find.textContaining('Partage'), findsOneWidget);

    // The tied deal shows the tie indicator
    expect(find.byIcon(Icons.compare_arrows), findsOneWidget);
  });

  test('SuitAssets.forContract maps every contract to a known asset', () {
    for (final type in ContractType.values) {
      final suit = SuitAssets.forContract(type);
      expect(suit.assetPath, startsWith('assets/suits/'));
      expect(suit.assetPath, endsWith('.svg'));
    }
  });

  testWidgets('back button is rendered and tappable', (tester) async {
    final game = _gameWithDeals([
      _deal(
        contract: ContractType.spades,
        result: ResultType.weWin,
        ours: 162,
        theirs: 0,
      ),
    ]);

    await tester.binding.setSurfaceSize(const Size(600, 1400));
    await tester.pumpWidget(_wrap(game));
    await tester.pumpAndSettle();

    // The back button is rendered in the AppBar via a Tooltip-wrapped IconButton.
    expect(find.byTooltip('Retour'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byTooltip('Retour'),
        matching: find.byIcon(Icons.arrow_back),
      ),
      findsOneWidget,
    );
  });
}
