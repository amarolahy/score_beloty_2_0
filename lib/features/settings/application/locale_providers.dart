import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../game/application/game_providers.dart';

const String localePrefsKey = 'locale_v1';

const Locale fallbackLocale = Locale('fr');

final List<Locale> supportedLocales = <Locale>[
  Locale('fr'),
  Locale('en'),
  Locale('mg'),
];

bool _isBuiltInSupported(Locale locale) {
  return GlobalMaterialLocalizations.delegate.isSupported(locale) &&
      GlobalCupertinoLocalizations.delegate.isSupported(locale);
}

Locale parseLocale(String? tag) {
  if (tag == null || tag.isEmpty) return fallbackLocale;
  final parts = tag.split('-');
  if (parts.length == 1) return Locale(parts[0]);
  return Locale(parts[0], parts[1]);
}

String serializeLocale(Locale locale) {
  if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
    return '${locale.languageCode}-${locale.countryCode}';
  }
  return locale.languageCode;
}

class _MaterialFallbackDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _MaterialFallbackDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    if (_isBuiltInSupported(locale)) {
      return GlobalMaterialLocalizations.delegate.load(locale);
    }
    return GlobalMaterialLocalizations.delegate.load(fallbackLocale);
  }

  @override
  bool shouldReload(_MaterialFallbackDelegate old) => false;
}

class _CupertinoFallbackDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CupertinoFallbackDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    if (_isBuiltInSupported(locale)) {
      return GlobalCupertinoLocalizations.delegate.load(locale);
    }
    return GlobalCupertinoLocalizations.delegate.load(fallbackLocale);
  }

  @override
  bool shouldReload(_CupertinoFallbackDelegate old) => false;
}

const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates =
    <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  _MaterialFallbackDelegate(),
  _CupertinoFallbackDelegate(),
  GlobalWidgetsLocalizations.delegate,
];

class LocaleController extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    return parseLocale(prefs.getString(localePrefsKey));
  }

  Future<void> set(Locale locale) async {
    state = AsyncData(locale);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(localePrefsKey, serializeLocale(locale));
  }
}

final localeControllerProvider =
    AsyncNotifierProvider<LocaleController, Locale>(LocaleController.new);

final currentLocaleProvider = Provider<Locale>((ref) {
  final asyncLocale = ref.watch(localeControllerProvider);
  return asyncLocale.maybeWhen(
    data: (l) => l,
    orElse: () => fallbackLocale,
  );
});
