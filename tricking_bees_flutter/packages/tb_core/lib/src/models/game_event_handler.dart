import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:yust/yust.dart';

import 'game/tb_game.dart';

/// An event of the game.
abstract class GameEventHandler {
  /// Whether this event is currently active.
  /// If an event is active, its effects are currently needed to be considered.
  bool isActive(TBGame game) => false;

  /// Handle start-of-round effects triggered by the event.
  Future<void> onStartOfRound(TBGame game) async {}

  /// Handle end-of-round effects triggered by the event.
  void onEndOfRound(TBGame game) {}

  /// Handle the start of the turn.
  Future<void> onStartOfTurn(TBGame game) async {}

  /// Handle the end of the turn.
  void onEndOfTurn(TBGame game) {}

  /// Retrieve the status message displayed during the special phase of the
  /// card or event.
  TrObject? getSpecialStatusMessage(TBGame game, YustUser? user) => null;

  /// Retrieve the status message that is displayed whenever this card or event
  /// is active, and the user is prompted to select a move.
  TrObject? getStatusWhileActive(TBGame game, YustUser? user) => null;
}
