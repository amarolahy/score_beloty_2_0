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
import 'package:score_beloty_2_0/l10n/generated/app_localizations.dart';

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
  const _SeededScreen({required this.game, this.locale});

  final Game game;
  final Locale? locale;

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
    return MaterialApp(
      locale: widget.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('fr'), Locale('en')],
      home: const DealsHistoryScreen(),
    );
  }
}

Widget _wrap(Game game, {Locale locale = const Locale('fr')}) {
  return ProviderScope(
    child: _SeededScreen(game: game, locale: locale),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    await initializeDateFormatting('en_US');
  });

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('renders an empty state when there are no deals (FR)',
      (tester) async {
    final game = _gameWithDeals(const <Deal>[]);
    String? emptyLabel;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('fr'), Locale('en')],
      home: Builder(
        builder: (context) {
          emptyLabel = AppLocalizations.of(context).noDealsRecorded;
          return _wrap(game);
        },
      ),
    ));
    await tester.pumpAndSettle();

    expect(emptyLabel, isNotNull);
    expect(find.text(emptyLabel!), findsOneWidget);
  });

  testWidgets('renders an empty state when there are no deals (EN)',
      (tester) async {
    final game = _gameWithDeals(const <Deal>[]);
    String? emptyLabel;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('fr'), Locale('en')],
      home: Builder(
        builder: (context) {
          emptyLabel = AppLocalizations.of(context).noDealsRecorded;
          return _wrap(game, locale: const Locale('en'));
        },
      ),
    ));
    await tester.pumpAndSettle();

    expect(emptyLabel, 'No deals recorded for this game.');
    expect(find.text(emptyLabel!), findsOneWidget);
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

    String? spades;
    String? hearts;
    String? taShort;
    String? won;
    String? lost;
    String? split;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('fr'), Locale('en')],
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          spades = l10n.contractShortSpades;
          hearts = l10n.contractShortHearts;
          taShort = l10n.contractShortAllTrumps;
          won = l10n.resultWon;
          lost = l10n.resultLost;
          split = l10n.resultSplit;
          return _wrap(game);
        },
      ),
    ));
    await tester.binding.setSurfaceSize(const Size(600, 1400));
    await tester.pumpAndSettle();

    expect(find.byType(SuitIcon), findsNWidgets(3));

    expect(find.textContaining(spades!), findsOneWidget);
    expect(find.textContaining(hearts!), findsOneWidget);
    expect(find.textContaining(taShort!), findsOneWidget);

    expect(find.textContaining(won!), findsOneWidget);
    expect(find.textContaining(lost!), findsOneWidget);
    expect(find.textContaining(split!), findsOneWidget);

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

    String? backTooltip;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('fr'), Locale('en')],
      home: Builder(
        builder: (context) {
          backTooltip = AppLocalizations.of(context).backTooltip;
          return _wrap(game);
        },
      ),
    ));
    await tester.binding.setSurfaceSize(const Size(600, 1400));
    await tester.pumpAndSettle();

    expect(find.byTooltip(backTooltip!), findsOneWidget);
    expect(
      find.descendant(
        of: find.byTooltip(backTooltip!),
        matching: find.byIcon(Icons.arrow_back),
      ),
      findsOneWidget,
    );
  });
}
