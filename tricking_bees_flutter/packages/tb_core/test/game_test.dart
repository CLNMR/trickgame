import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:tb_core/tb_core.dart';
import 'package:test/test.dart';
import 'package:yust/yust.dart';

/// A [TBGame] subclass that overrides [save] with a no-op for testing
/// without a Firestore backend.
class TestTBGame extends TBGame {
  @override
  Future<void> save({
    bool merge = true,
    bool? trackModification,
    bool skipOnSave = false,
    bool? removeNullValues,
    bool doNotCreate = false,
  }) async {}

  @override
  TBGame init() => this;
}

void main() {
  late TestTBGame game;
  late YustUser user1;
  late YustUser user2;
  late YustUser user3;

  setUpAll(() {
    LogEntryType.values.insertAll(0, TBLogEntryType.values);
  });

  setUp(() {
    game = TestTBGame();
    user1 = YustUser(email: '', firstName: 'Colin', lastName: 't1');
    user2 = YustUser(email: '', firstName: 'Fabi', lastName: 't2');
    user3 = YustUser(email: '', firstName: 'Sanne', lastName: 't3');
  });

  test('addUser', () async {
    await game.tryAddUser(user1);
    await game.tryAddUser(user2);
    await game.tryAddUser(user3);
    expect(game.players.toSet(), {
      Player.fromUser(user1),
      Player.fromUser(user2),
      Player.fromUser(user3),
    });
  });

  test('getLogEntries', () {
    final logEntries = game.getLogEntries(round: 1);
    expect(logEntries, []);
  });
}
