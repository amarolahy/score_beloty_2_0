import 'package:flutter_test/flutter_test.dart';
import 'package:score_beloty_2_0/core/result.dart';
import 'package:score_beloty_2_0/features/game/data/game_repository.dart';
import 'package:score_beloty_2_0/features/game/data/game_storage.dart';
import 'package:score_beloty_2_0/features/game/domain/deal.dart';
import 'package:score_beloty_2_0/features/game/domain/game.dart';
import 'package:score_beloty_2_0/features/game/domain/rules.dart';
import 'package:score_beloty_2_0/features/game/domain/team.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _teams = (
  us: Team(player1: 'A', player2: 'B'),
  them: Team(player1: 'C', player2: 'D'),
);

Game _game({
  DateTime? createdOn,
  List<Deal> deals = const <Deal>[],
}) {
  return Game.fresh(
    us: _teams.us,
    them: _teams.them,
    rules: const Rules(),
    deals: deals,
    createdOn: createdOn,
  );
}

T _unwrap<T>(SealedResult<T> result) {
  if (result is Success<T>) return result.value;
  throw (result as Failure<T>).cause ?? Exception(result.message);
}

Future<GameRepository> _newRepo() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  return GameRepository(GameStorage(prefs));
}

void main() {
  group('GameRepository', () {
    test('returns empty list when storage is empty', () async {
      final repo = await _newRepo();
      final games = _unwrap(await repo.getAll());
      expect(games, isEmpty);
    });

    test('saves and retrieves a game', () async {
      final repo = await _newRepo();
      final g = _game(createdOn: DateTime(2026, 1, 1));
      _unwrap(await repo.save(g));
      final loaded = _unwrap(await repo.getAll());
      expect(loaded, hasLength(1));
      expect(loaded.first.createdOn, g.createdOn);
    });

    test('save updates an existing game (same createdOn)', () async {
      final repo = await _newRepo();
      final created = DateTime(2026, 1, 1);
      _unwrap(await repo.save(_game(createdOn: created)));
      _unwrap(await repo.save(
        _game(
          createdOn: created,
          deals: [
            Deal(
              contract: ContractType.allTrumps,
              bid: BidType.pass,
              beginAt: DateTime(2026, 1, 2),
              result: ResultType.weWin,
              ourPoints: 80,
              theirPoints: 40,
            ),
          ],
        ),
      ));
      final loaded = _unwrap(await repo.getAll());
      expect(loaded, hasLength(1));
      expect(loaded.first.deals, hasLength(1));
      expect(loaded.first.ourScore, 80);
    });

    test('getAll returns games sorted by createdOn descending', () async {
      final repo = await _newRepo();
      _unwrap(await repo.save(_game(createdOn: DateTime(2026, 1, 1))));
      _unwrap(await repo.save(_game(createdOn: DateTime(2026, 3, 1))));
      _unwrap(await repo.save(_game(createdOn: DateTime(2026, 2, 1))));
      final loaded = _unwrap(await repo.getAll());
      expect(loaded.map((g) => g.createdOn).toList(), [
        DateTime(2026, 3, 1),
        DateTime(2026, 2, 1),
        DateTime(2026, 1, 1),
      ]);
    });

    test('findLast returns the most recent game', () async {
      final repo = await _newRepo();
      _unwrap(await repo.save(_game(createdOn: DateTime(2026, 1, 1))));
      _unwrap(await repo.save(_game(createdOn: DateTime(2026, 5, 1))));
      final last = _unwrap(await repo.findLast());
      expect(last, isNotNull);
      expect(last!.createdOn, DateTime(2026, 5, 1));
    });

    test('findLast returns null when no game exists', () async {
      final repo = await _newRepo();
      expect(_unwrap(await repo.findLast()), isNull);
    });

    test('findByCreatedOn returns matching game or null', () async {
      final repo = await _newRepo();
      final created = DateTime(2026, 4, 1);
      _unwrap(await repo.save(_game(createdOn: created)));
      final found = _unwrap(await repo.findByCreatedOn(created));
      expect(found?.createdOn, created);
      expect(_unwrap(await repo.findByCreatedOn(DateTime(2030, 1, 1))), isNull);
    });

    test('delete removes the targeted game only', () async {
      final repo = await _newRepo();
      final a = DateTime(2026, 1, 1);
      final b = DateTime(2026, 2, 1);
      _unwrap(await repo.save(_game(createdOn: a)));
      _unwrap(await repo.save(_game(createdOn: b)));
      _unwrap(await repo.delete(a));
      final loaded = _unwrap(await repo.getAll());
      expect(loaded, hasLength(1));
      expect(loaded.first.createdOn, b);
    });

    test('storage silently skips corrupted JSON entries', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'games_v2': ['not-json', '{"us":{}}'],
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = GameRepository(GameStorage(prefs));
      // Corrupted entries are silently skipped; loadAll still succeeds with
      // whatever valid games were stored.
      final result = await repo.getAll();
      expect(result, isA<Success<List<Game>>>());
      expect(_unwrap(result), isEmpty);
    });

    test('partial corruption returns the valid games only', () async {
      final validJson =
          '{"us":{"player1":"A","player2":"B","initialScore":0},"them":{"player1":"C","player2":"D","initialScore":0},"rules":{"finalScore":150,"splitAllTrumps":true,"splitNoTrumps":false,"splitColor":false,"continueOnTie":true,"stepsOnTie":50,"pointIfError":true,"pointOnError":10,"winIfCapotInside":false,"redoubleNoTrumps":false,"atStake":false,"bet":false,"betAmount":0,"doubleAmountOnCapotScore":true},"deals":[],"state":"begin","createdOn":"2026-01-01T00:00:00.000","effectiveFinalScore":null}';
      SharedPreferences.setMockInitialValues(<String, Object>{
        'games_v2': [validJson, 'not-json', 'also-broken'],
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = GameRepository(GameStorage(prefs));
      final result = await repo.getAll();
      expect(result, isA<Success<List<Game>>>());
      final games = _unwrap(result);
      expect(games, hasLength(1));
      expect(games.first.createdOn, DateTime(2026, 1, 1));
    });
  });
}
