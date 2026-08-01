import '../../../core/result.dart';
import '../domain/game.dart';
import 'game_storage.dart';

class GameRepository {
  GameRepository(this._storage);

  final GameStorage _storage;

  Future<SealedResult<List<Game>>> getAll() async {
    final loaded = await _storage.loadAll();
    if (loaded is Failure<List<Game>>) {
      return Failure<List<Game>>(loaded.message, cause: loaded.cause);
    }
    final games = [...(loaded as Success<List<Game>>).value]
      ..sort((a, b) => b.createdOn.compareTo(a.createdOn));
    return Success(games);
  }

  Future<SealedResult<Game?>> findByCreatedOn(DateTime createdOn) async {
    final loaded = await _storage.loadAll();
    if (loaded is Failure<List<Game>>) {
      return Failure<Game?>(loaded.message, cause: loaded.cause);
    }
    for (final g in (loaded as Success<List<Game>>).value) {
      if (g.createdOn == createdOn) return Success(g);
    }
    return const Success(null);
  }

  Future<SealedResult<Game?>> findLast() async {
    final result = await getAll();
    if (result is Failure<List<Game>>) {
      return Failure<Game?>(result.message, cause: result.cause);
    }
    final games = (result as Success<List<Game>>).value;
    return Success(games.isEmpty ? null : games.first);
  }

  Future<SealedResult<Game>> save(Game game) async {
    final loaded = await _storage.loadAll();
    if (loaded is Failure<List<Game>>) {
      return Failure<Game>(loaded.message, cause: loaded.cause);
    }
    final games = [...(loaded as Success<List<Game>>).value];
    final index = games.indexWhere((g) => g.createdOn == game.createdOn);
    if (index >= 0) {
      games[index] = game;
    } else {
      games.add(game);
    }
    final saved = await _storage.saveAll(games);
    if (saved is Failure<void>) {
      return Failure<Game>(saved.message, cause: saved.cause);
    }
    return Success(game);
  }

  Future<SealedResult<void>> delete(DateTime createdOn) async {
    final loaded = await _storage.loadAll();
    if (loaded is Failure<List<Game>>) {
      return Failure<void>(loaded.message, cause: loaded.cause);
    }
    final games = [...(loaded as Success<List<Game>>).value]
      ..removeWhere((g) => g.createdOn == createdOn);
    final cleared = await _storage.saveAll(games);
    if (cleared is Failure<void>) {
      return Failure<void>(cleared.message, cause: cleared.cause);
    }
    return const Success(null);
  }
}
