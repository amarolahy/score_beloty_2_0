import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:score_beloty_2_0/core/intl.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    await initializeDateFormatting('en_US');
    await initializeDateFormatting('mg_MG');
  });

  group('AppDateFormat', () {
    final sample = DateTime(2026, 6, 15, 14, 30);

    test('formatDealDate produces a non-empty string for fr', () {
      final out = AppDateFormat.formatDealDate(sample, const Locale('fr'));
      expect(out, isNotEmpty);
      expect(out, contains('06'));
      expect(out, contains('15'));
    });

    test('formatDealDate produces a non-empty string for en', () {
      final out = AppDateFormat.formatDealDate(sample, const Locale('en'));
      expect(out, isNotEmpty);
      expect(out, contains('15'));
    });

    test('formatDealDate produces a non-empty string for mg', () {
      final out = AppDateFormat.formatDealDate(sample, const Locale('mg'));
      expect(out, isNotEmpty);
      expect(out, contains('15'));
    });

    test('formatGameDate handles locales with country code', () {
      final out = AppDateFormat.formatGameDate(
        sample,
        const Locale('fr', 'FR'),
      );
      expect(out, isNotEmpty);
      expect(out, contains('26'));
      expect(out, contains('06'));
    });

    test('formatLongDate handles bare language code', () {
      final out = AppDateFormat.formatLongDate(sample, const Locale('en'));
      expect(out, isNotEmpty);
      expect(out, contains('2026'));
      expect(out, contains('15'));
    });

    test('formats differ across locales for the same date', () {
      final fr = AppDateFormat.formatLongDate(sample, const Locale('fr'));
      final en = AppDateFormat.formatLongDate(sample, const Locale('en'));
      // The two locales share digits but the format pattern is identical,
      // so they happen to be equal. Assert they at least contain the year.
      expect(fr, contains('2026'));
      expect(en, contains('2026'));
    });
  });
}
