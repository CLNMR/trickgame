import 'dart:math';

import 'package:yust/yust.dart';

import '../cards/card_color.dart';
import '../models/game/game.dart';
import '../wrapper/rich_tr_object.dart';
import '../wrapper/rich_tr_object_type.dart';
import '../wrapper/tr_object.dart';
import 'role.dart';
import 'role_catalog.dart';

/// None of their cards is trump, and they desire to score as little as
/// possible.
class RoleI extends Role {
  /// Creates a [RoleI].
  RoleI() : super(key: RoleCatalog.roleI);

  @override
  int calculatePoints(Game game, int tricksWon) => max(0, 8 - tricksWon * 2);

  @override
  TrObject getStatusWhileActive(Game game, YustUser? user) => TrObject(
        key.statusKey,
        richTrObjects: [
          RichTrObject(
            RichTrType.color,
            value: game.currentTrumpColor ?? CardColor.noColor,
          ),
        ],
      );
}
