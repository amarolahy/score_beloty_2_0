import 'package:flutter_test/flutter_test.dart';
import 'package:score_beloty_2_0/core/failures.dart';

void main() {
  group('StorageFailure', () {
    test('PreferencesUnavailable has a sensible default message', () {
      const failure = PreferencesUnavailable();
      expect(failure.message, contains('SharedPreferences'));
      expect(failure.cause, isNull);
    });

    test('PreferencesUnavailable can carry a custom cause', () {
      final cause = StateError('platform-channel-error');
      final failure = PreferencesUnavailable(cause: cause);
      expect(failure.cause, cause);
    });

    test('CorruptedEntry exposes the offending key', () {
      const failure = CorruptedEntry('games_v2');
      expect(failure.key, 'games_v2');
      expect(failure.message, contains('games_v2'));
    });

    test('NotFound exposes the identifier', () {
      const failure = NotFound('2026-08-01T10:00:00');
      expect(failure.identifier, '2026-08-01T10:00:00');
      expect(failure.message, contains('2026-08-01T10:00:00'));
    });

    test('toString mentions the runtime type', () {
      const failure = CorruptedEntry('games_v2');
      expect(failure.toString(), startsWith('CorruptedEntry'));
    });
  });
}
