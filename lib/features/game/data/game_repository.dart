import '../domain/game.dart';
import 'game_storage.dart';

class GameRepository {
  GameRepository(this._storage);

  final GameStorage _storage;

  Future<List<Game>> getAll() async {
    final games = await _storage.loadAll();
    games.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    return games;
  }

  Future<Game?> findByCreatedOn(DateTime createdOn) async {
    final games = await _storage.loadAll();
    for (final g in games) {
      if (g.createdOn == createdOn) return g;
    }
    return null;
  }

  Future<Game?> findLast() async {
    final games = await getAll();
    return games.isEmpty ? null : games.first;
  }

  Future<Game> save(Game game) async {
    final games = await _storage.loadAll();
    final index =
        games.indexWhere((g) => g.createdOn == game.createdOn);
    if (index >= 0) {
      games[index] = game;
    } else {
      games.add(game);
    }
    await _storage.saveAll(games);
    return game;
  }

  Future<void> delete(DateTime createdOn) async {
    final games = await _storage.loadAll();
    games.removeWhere((g) => g.createdOn == createdOn);
    await _storage.saveAll(games);
  }
}
