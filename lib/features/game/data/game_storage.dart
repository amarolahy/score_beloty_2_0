import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/failures.dart';
import '../../../core/result.dart';
import '../domain/game.dart';

class GameStorage {
  GameStorage(this._prefs);

  static const String storageKey = 'games_v2';

  final SharedPreferences _prefs;

  /// Reads every stored game. Corrupted JSON entries are silently skipped so
  /// the rest of the data remains usable; only platform-level errors
  /// (prefs unavailable, etc.) surface as [Failure].
  Future<SealedResult<List<Game>>> loadAll() async {
    final raw = _prefs.getStringList(storageKey);
    if (raw == null) return const Success(<Game>[]);

    final games = <Game>[];
    for (final entry in raw) {
      try {
        final json = jsonDecode(entry) as Map<String, dynamic>;
        games.add(Game.fromJson(json));
      } catch (_) {
        // Skip corrupted entries silently.
      }
    }
    return Success(games);
  }

  Future<SealedResult<void>> saveAll(List<Game> games) async {
    try {
      final serialized = games.map((g) => jsonEncode(g.toJson())).toList();
      await _prefs.setStringList(storageKey, serialized);
      return const Success(null);
    } catch (e) {
      return Failure<void>(
        'Failed to save games',
        cause: PreferencesUnavailable(cause: e),
      );
    }
  }

  Future<SealedResult<void>> clear() async {
    try {
      await _prefs.remove(storageKey);
      return const Success(null);
    } catch (e) {
      return Failure<void>(
        'Failed to clear storage',
        cause: PreferencesUnavailable(cause: e),
      );
    }
  }
}
