import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/result.dart';
import '../data/game_repository.dart';
import '../data/game_storage.dart';
import '../domain/game.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
});

final gameStorageProvider = Provider<GameStorage>((ref) {
  return GameStorage(ref.watch(sharedPreferencesProvider));
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository(ref.watch(gameStorageProvider));
});

T _unwrap<T>(SealedResult<T> result) {
  if (result is Success<T>) return result.value;
  final failure = result as Failure<T>;
  throw failure.cause ?? Exception(failure.message);
}

class GamesHistoryController extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() async {
    return _unwrap(await ref.read(gameRepositoryProvider).getAll());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return _unwrap(await ref.read(gameRepositoryProvider).getAll());
    });
  }

  Future<void> remove(Game game) async {
    _unwrap(await ref.read(gameRepositoryProvider).delete(game.createdOn));
    await refresh();
  }
}

final gamesHistoryControllerProvider =
    AsyncNotifierProvider<GamesHistoryController, List<Game>>(
  GamesHistoryController.new,
);

class CurrentGameController extends Notifier<Game?> {
  @override
  Game? build() => null;

  CurrentGameController start(Game game) {
    state = game;
    return this;
  }

  CurrentGameController replace(Game game) {
    state = game;
    return this;
  }

  Future<void> persist() async {
    final current = state;
    if (current == null) return;
    _unwrap(await ref.read(gameRepositoryProvider).save(current));
    await ref.read(gamesHistoryControllerProvider.notifier).refresh();
  }

  Future<void> cancelLastDeal() async {
    final current = state;
    if (current == null) return;
    final next = current.removeLastDeal();
    if (next == null) return;
    state = next;
    _unwrap(await ref.read(gameRepositoryProvider).save(next));
  }

  void clear() {
    state = null;
  }
}

final currentGameControllerProvider =
    NotifierProvider<CurrentGameController, Game?>(
  CurrentGameController.new,
);
