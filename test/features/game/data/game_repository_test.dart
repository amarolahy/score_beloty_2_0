import 'package:flutter_test/flutter_test.dart';
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

Future<GameRepository> _newRepo() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  return GameRepository(GameStorage(prefs));
}

void main() {
  group('GameRepository', () {
    test('returns empty list when storage is empty', () async {
      final repo = await _newRepo();
      expect(await repo.getAll(), isEmpty);
    });

    test('saves and retrieves a game', () async {
      final repo = await _newRepo();
      final g = _game(createdOn: DateTime(2026, 1, 1));
      await repo.save(g);
      final loaded = await repo.getAll();
      expect(loaded, hasLength(1));
      expect(loaded.first.createdOn, g.createdOn);
    });

    test('save updates an existing game (same createdOn)', () async {
      final repo = await _newRepo();
      final created = DateTime(2026, 1, 1);
      await repo.save(_game(createdOn: created));
      await repo.save(
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
      );
      final loaded = await repo.getAll();
      expect(loaded, hasLength(1));
      expect(loaded.first.deals, hasLength(1));
      expect(loaded.first.ourScore, 80);
    });

    test('getAll returns games sorted by createdOn descending', () async {
      final repo = await _newRepo();
      await repo.save(_game(createdOn: DateTime(2026, 1, 1)));
      await repo.save(_game(createdOn: DateTime(2026, 3, 1)));
      await repo.save(_game(createdOn: DateTime(2026, 2, 1)));
      final loaded = await repo.getAll();
      expect(loaded.map((g) => g.createdOn).toList(), [
        DateTime(2026, 3, 1),
        DateTime(2026, 2, 1),
        DateTime(2026, 1, 1),
      ]);
    });

    test('findLast returns the most recent game', () async {
      final repo = await _newRepo();
      await repo.save(_game(createdOn: DateTime(2026, 1, 1)));
      await repo.save(_game(createdOn: DateTime(2026, 5, 1)));
      final last = await repo.findLast();
      expect(last, isNotNull);
      expect(last!.createdOn, DateTime(2026, 5, 1));
    });

    test('findLast returns null when no game exists', () async {
      final repo = await _newRepo();
      expect(await repo.findLast(), isNull);
    });

    test('findByCreatedOn returns matching game or null', () async {
      final repo = await _newRepo();
      final created = DateTime(2026, 4, 1);
      await repo.save(_game(createdOn: created));
      expect((await repo.findByCreatedOn(created))?.createdOn, created);
      expect(await repo.findByCreatedOn(DateTime(2030, 1, 1)), isNull);
    });

    test('delete removes the targeted game only', () async {
      final repo = await _newRepo();
      final a = DateTime(2026, 1, 1);
      final b = DateTime(2026, 2, 1);
      await repo.save(_game(createdOn: a));
      await repo.save(_game(createdOn: b));
      await repo.delete(a);
      final loaded = await repo.getAll();
      expect(loaded, hasLength(1));
      expect(loaded.first.createdOn, b);
    });

    test('storage tolerates corrupted entries', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'games_v2': ['not-json', '{"us":{}}'],
      });
      final prefs = await SharedPreferences.getInstance();
      final repo = GameRepository(GameStorage(prefs));
      expect(await repo.getAll(), isEmpty);
    });
  });
}
