import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/game.dart';

class GameStorage {
  GameStorage(this._prefs);

  static const String storageKey = 'games_v2';

  final SharedPreferences _prefs;

  Future<List<Game>> loadAll() async {
    final raw = _prefs.getStringList(storageKey);
    if (raw == null) return <Game>[];
    final games = <Game>[];
    for (final entry in raw) {
      try {
        final json = jsonDecode(entry) as Map<String, dynamic>;
        games.add(Game.fromJson(json));
      } catch (_) {
        // Skip corrupted entries silently; we could log instead.
      }
    }
    return games;
  }

  Future<void> saveAll(List<Game> games) async {
    final serialized = games.map((g) => jsonEncode(g.toJson())).toList();
    await _prefs.setStringList(storageKey, serialized);
  }

  Future<void> clear() async {
    await _prefs.remove(storageKey);
  }
}
