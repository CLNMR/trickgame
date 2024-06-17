import 'package:tb_core/src/models/player.dart';
import 'package:tb_core/tb_core.dart';
import 'package:test/test.dart';
import 'package:yust/yust.dart';

void main() {
  late Game game;
  late YustUser user1;
  late YustUser user2;
  late YustUser user3;
  setUp(() {
    // TODO: Initialize Yust with mock database
    game = Game();
    user1 = YustUser(email: '', firstName: 'Colin', lastName: 't1');
    user2 = YustUser(email: '', firstName: 'Fabi', lastName: 't2');
    user3 = YustUser(email: '', firstName: 'Sanne', lastName: 't3');
  });

  test('addUser', () async {
    await game.addUser(user1);
    await game.addUser(user2);
    await game.addUser(user3);
    expect(game.players.toSet(), {
      Player.fromUser(user1),
      Player.fromUser(user2),
      Player.fromUser(user3),
    });
  });

  test('getLogEntries', () {
    final logEntries = game.getLogEntries(1);
    expect(logEntries, []);
  });
}

// simulateBiddingPhase(Game game) {
//   game.acceptOfferAndSetSolo(user)
//   }
