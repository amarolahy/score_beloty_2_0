import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'features/game/application/game_providers.dart';
import 'features/settings/application/locale_providers.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
  await initializeDateFormatting('en_US');
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ScoreBelotyApp(),
    ),
  );
}

class ScoreBelotyApp extends ConsumerWidget {
  const ScoreBelotyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);
    final locale = ref.watch(currentLocaleProvider);
    return MaterialApp.router(
      title: 'Score Beloty',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}

final _routerProvider = Provider((ref) => buildRouter());
