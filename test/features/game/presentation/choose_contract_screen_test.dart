import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:score_beloty_2_0/features/game/application/game_providers.dart';
import 'package:score_beloty_2_0/features/game/domain/deal.dart';
import 'package:score_beloty_2_0/features/game/domain/game.dart';
import 'package:score_beloty_2_0/features/game/domain/rules.dart';
import 'package:score_beloty_2_0/features/game/domain/team.dart';
import 'package:score_beloty_2_0/features/game/presentation/screens/choose_contract_screen.dart';

Widget _harness({required Game game}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWith(
        (ref) => throw UnimplementedError('not used in widget test'),
      ),
    ],
    child: MaterialApp(
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

/// Wraps the screen in a stateful harness that seeds a current game.
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

  testWidgets('choose contract renders six SVG suit tiles', (tester) async {
    final game = Game.fresh(
      us: const Team(player1: 'A', player2: 'B'),
      them: const Team(player1: 'C', player2: 'D'),
      rules: const Rules(),
    );

    await tester.pumpWidget(_harness(game: game));
    await tester.pumpAndSettle();

    // Six suit labels rendered
    expect(find.text('Tout atout'), findsOneWidget);
    expect(find.text('Sans atout'), findsOneWidget);
    expect(find.text('Pique'), findsOneWidget);
    expect(find.text('Cœur'), findsOneWidget);
    expect(find.text('Carreau'), findsOneWidget);
    expect(find.text('Trèfle'), findsOneWidget);

    // Six SvgPicture widgets loaded
    expect(find.byType(SvgPicture), findsNWidgets(6));
  });

  testWidgets('selecting a different contract updates the preview total',
      (tester) async {
    final game = Game.fresh(
      us: const Team(player1: 'A', player2: 'B'),
      them: const Team(player1: 'C', player2: 'D'),
      rules: const Rules(),
    );

    await tester.binding.setSurfaceSize(const Size(600, 1800));
    await tester.pumpWidget(_harness(game: game));
    await tester.pumpAndSettle();

    // Scroll the ListView so the preview is in view
    await tester.scrollUntilVisible(
      find.text('Mise calculée'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Initial contract is AllTrumps → 26 points
    expect(find.text('26 points'), findsOneWidget);

    // Tap "Pique" (16 base)
    await tester.tap(find.text('Pique'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Mise calculée'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('16 points'), findsOneWidget);
  });
}
