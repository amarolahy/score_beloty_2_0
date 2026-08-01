import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Locale-aware date formatting helpers.
///
/// Use [_localeTag] to convert a [Locale] to the underscore-separated tag
/// expected by `DateFormat` (e.g. `Locale('fr', 'FR')` → `'fr_FR'`).
class AppDateFormat {
  AppDateFormat._();

  /// Short label used in deals history (`EEE dd/MM HH:mm`).
  static String formatDealDate(DateTime date, Locale locale) {
    return DateFormat('EEE dd/MM HH:mm', _localeTag(locale)).format(date);
  }

  /// Longer label used in game info (`EEE dd/MM/yy HH:mm`).
  static String formatGameDate(DateTime date, Locale locale) {
    return DateFormat('EEE dd/MM/yy HH:mm', _localeTag(locale)).format(date);
  }

  /// Full label used in game over (`dd/MM/yyyy HH:mm`).
  static String formatLongDate(DateTime date, Locale locale) {
    return DateFormat('dd/MM/yyyy HH:mm', _localeTag(locale)).format(date);
  }

  static String _localeTag(Locale locale) {
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }
}
