import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:score_beloty_2_0/features/game/domain/deal.dart';
import 'package:score_beloty_2_0/features/game/presentation/screens/modal_split_score_screen.dart';
import 'package:score_beloty_2_0/l10n/generated/app_localizations.dart';

const _oursKey = ValueKey('ours-stepper');
const _theirsKey = ValueKey('theirs-stepper');

Widget _harness({ContractType contract = ContractType.spades}) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: const [Locale('fr'), Locale('en')],
    home: ModalSplitScoreScreen(contract: contract),
  );
}

Future<void> _pump(WidgetTester tester,
    {ContractType contract = ContractType.spades}) async {
  await tester.pumpWidget(_harness(contract: contract));
  await tester.pumpAndSettle();
}

Finder _plus(Key stepperKey) => find.descendant(
      of: find.byKey(stepperKey),
      matching: find.byIcon(Icons.add_circle_outline),
    );

Finder _minus(Key stepperKey) => find.descendant(
      of: find.byKey(stepperKey),
      matching: find.byIcon(Icons.remove_circle_outline),
    );

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('defaults come from ContractSplit (suit: 9 / 7)', (tester) async {
    await _pump(tester);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('+ on "Our score" gives us 1 point and takes 1 from "Their score"',
      (tester) async {
    await _pump(tester, contract: ContractType.spades);

    await _tap(tester, _plus(_oursKey));

    expect(find.text('10'), findsOneWidget); // ours
    expect(find.text('6'), findsOneWidget); // theirs
  });

  testWidgets('- on "Our score" takes 1 from us and gives 1 to "Their score"',
      (tester) async {
    await _pump(tester, contract: ContractType.spades);

    await _tap(tester, _minus(_oursKey));

    expect(find.text('8'), findsWidgets); // ours = 8, theirs = 8
  });

  testWidgets('+ on "Their score" gives them a point at our expense',
      (tester) async {
    await _pump(tester, contract: ContractType.spades);

    await _tap(tester, _plus(_theirsKey));

    expect(find.text('8'), findsWidgets); // ours = 8, theirs = 8
  });

  testWidgets('- on "Their score" takes 1 from them and gives 1 to us',
      (tester) async {
    await _pump(tester, contract: ContractType.spades);

    await _tap(tester, _minus(_theirsKey));

    expect(find.text('10'), findsOneWidget); // ours
    expect(find.text('6'), findsOneWidget); // theirs
  });

  testWidgets(
      'tapping + on "Our score" beyond maxPerTeam has no effect',
      (tester) async {
    // spades: maxPerTeam=11, total=16. Defaults 9/7. After + + → 11/5.
    await _pump(tester, contract: ContractType.spades);

    await _tap(tester, _plus(_oursKey));
    await _tap(tester, _plus(_oursKey));
    expect(find.text('11'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);

    // Further taps should not change anything.
    await _tap(tester, _plus(_oursKey));
    await _tap(tester, _plus(_oursKey));
    expect(find.text('11'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets(
      'tapping - on "Our score" past the point where theirs would overflow '
      'has no effect', (tester) async {
    // spades: maxPerTeam=11. Ours can drop to 5 before theirs would hit 11.
    await _pump(tester, contract: ContractType.spades);

    for (var i = 0; i < 4; i++) {
      await _tap(tester, _minus(_oursKey));
    }
    expect(find.text('5'), findsOneWidget); // ours
    expect(find.text('11'), findsOneWidget); // theirs at max

    // Further taps must not change anything.
    await _tap(tester, _minus(_oursKey));
    expect(find.text('5'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
  });

  testWidgets('for the "error" contract, +/- are no-ops (maxPerTeam=0)',
      (tester) async {
    await _pump(tester, contract: ContractType.error);

    expect(find.text('0'), findsWidgets); // ours = 0, theirs = 0

    await _tap(tester, _plus(_oursKey));
    await _tap(tester, _minus(_oursKey));
    await _tap(tester, _plus(_theirsKey));
    await _tap(tester, _minus(_theirsKey));

    expect(find.text('0'), findsWidgets);
    expect(find.text('16'), findsNothing);
  });

  testWidgets('score stepper works the same way for the all-trumps contract',
      (tester) async {
    // all-trumps: total=26, maxPerTeam=18, defaults (14, 12).
    await _pump(tester, contract: ContractType.allTrumps);

    expect(find.text('14'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);

    await _tap(tester, _plus(_oursKey));
    expect(find.text('15'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
  });
}
