import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:score_beloty_2_0/features/game/application/game_providers.dart';
import 'package:score_beloty_2_0/features/settings/application/locale_providers.dart';

Future<ProviderContainer> _makeContainer(
  Map<String, Object> initialPrefs,
) async {
  SharedPreferences.setMockInitialValues(initialPrefs);
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('parseLocale falls back to French on null/empty', () {
    expect(parseLocale(null).languageCode, 'fr');
    expect(parseLocale('').languageCode, 'fr');
  });

  test('parseLocale handles simple and country codes', () {
    expect(parseLocale('en').languageCode, 'en');
    expect(parseLocale('fr-FR').languageCode, 'fr');
    expect(parseLocale('fr-FR').countryCode, 'FR');
    expect(parseLocale('en-US').countryCode, 'US');
  });

  test('serializeLocale drops country when missing', () {
    expect(serializeLocale(const Locale('fr')), 'fr');
    expect(serializeLocale(const Locale('fr', 'FR')), 'fr-FR');
    expect(serializeLocale(const Locale('en', 'US')), 'en-US');
  });

  test('LocaleController reads default locale from empty prefs', () async {
    final container = await _makeContainer(<String, Object>{});
    final locale = await container.read(localeControllerProvider.future);
    expect(locale.languageCode, 'fr');
  });

  test('LocaleController reads stored locale', () async {
    final container = await _makeContainer(<String, Object>{
      localePrefsKey: 'en-US',
    });
    final locale = await container.read(localeControllerProvider.future);
    expect(locale.languageCode, 'en');
    expect(locale.countryCode, 'US');
  });

  test('LocaleController persists locale changes', () async {
    final container = await _makeContainer(<String, Object>{});
    await container.read(localeControllerProvider.future);

    await container
        .read(localeControllerProvider.notifier)
        .set(const Locale('en'));

    final current = container.read(currentLocaleProvider);
    expect(current.languageCode, 'en');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(localePrefsKey), 'en');
  });

  test('LocaleController updates currentLocaleProvider reactively', () async {
    final container = await _makeContainer(<String, Object>{});
    await container.read(localeControllerProvider.future);

    final initial = container.read(currentLocaleProvider);
    expect(initial.languageCode, 'fr');

    await container
        .read(localeControllerProvider.notifier)
        .set(const Locale('en', 'US'));

    final updated = container.read(currentLocaleProvider);
    expect(updated.languageCode, 'en');
    expect(updated.countryCode, 'US');
  });
}
