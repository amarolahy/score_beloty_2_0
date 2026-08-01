import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:score_beloty_2_0/features/game/application/game_providers.dart';
import 'package:score_beloty_2_0/features/game/domain/game.dart';
import 'package:score_beloty_2_0/features/game/domain/rules.dart';
import 'package:score_beloty_2_0/features/game/domain/team.dart';
import 'package:score_beloty_2_0/features/game/presentation/screens/choose_contract_screen.dart';
import 'package:score_beloty_2_0/l10n/generated/app_localizations.dart';

Widget _harness({required Game game, Locale locale = const Locale('fr')}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWith(
        (ref) => throw UnimplementedError('not used in widget test'),
      ),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('fr'), Locale('en')],
      home: Consumer(
        builder: (context, ref, _) {
          return Scaffold(
            body: ChooseContractScreenWithGame(game: game),
          );
        },
      ),
    ),
  );
}

class ChooseContractScreenWithGame extends ConsumerStatefulWidget {
  const ChooseContractScreenWithGame({super.key, required this.game});

  final Game game;

  @override
  ConsumerState<ChooseContractScreenWithGame> createState() =>
      _ChooseContractScreenWithGameState();
}

class _ChooseContractScreenWithGameState
    extends ConsumerState<ChooseContractScreenWithGame> {
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
    return const ChooseContractScreen();
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('choose contract renders six SVG suit tiles (FR)', (tester) async {
    final game = Game.fresh(
      us: const Team(player1: 'A', player2: 'B'),
      them: const Team(player1: 'C', player2: 'D'),
      rules: const Rules(),
    );

    await tester.pumpWidget(_harness(game: game));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(ChooseContractScreen));
    final l10n = AppLocalizations.of(context);

    expect(find.text(l10n.contractAllTrumps), findsOneWidget);
    expect(find.text(l10n.contractNoTrumps), findsOneWidget);
    expect(find.text(l10n.contractSpades), findsOneWidget);
    expect(find.text(l10n.contractHearts), findsOneWidget);
    expect(find.text(l10n.contractDiamonds), findsOneWidget);
    expect(find.text(l10n.contractClubs), findsOneWidget);
    expect(find.byType(SvgPicture), findsNWidgets(6));
  });

  testWidgets('choose contract renders six suit tiles (EN)', (tester) async {
    final game = Game.fresh(
      us: const Team(player1: 'A', player2: 'B'),
      them: const Team(player1: 'C', player2: 'D'),
      rules: const Rules(),
    );

    await tester.pumpWidget(_harness(game: game, locale: const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('All trumps'), findsOneWidget);
    expect(find.text('Spades'), findsOneWidget);
    expect(find.byType(SvgPicture), findsNWidgets(6));
  });

  testWidgets('selecting a different contract updates the preview total',
      (tester) async {
    final game = Game.fresh(
      us: const Team(player1: 'A', player2: 'B'),
      them: const Team(player1: 'C', player2: 'D'),
      rules: const Rules(),
    );

    String calculatedStake = '';
    String spadesLabel = '';
    await tester.pumpWidget(_harness(game: game));
    await tester.binding.setSurfaceSize(const Size(600, 1800));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(ChooseContractScreen));
    final l10n = AppLocalizations.of(context);
    calculatedStake = l10n.calculatedStake;
    spadesLabel = l10n.contractSpades;

    await tester.scrollUntilVisible(
      find.text(calculatedStake),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('26 points'), findsOneWidget);

    await tester.tap(find.text(spadesLabel));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(calculatedStake),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('16 points'), findsOneWidget);
  });
}
