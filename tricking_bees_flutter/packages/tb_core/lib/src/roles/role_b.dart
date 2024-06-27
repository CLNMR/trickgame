import 'package:yust/yust.dart';

import '../cards/card_color.dart';
import '../models/game/game.dart';
import '../wrapper/rich_tr_object.dart';
import '../wrapper/rich_tr_object_type.dart';
import '../wrapper/tr_object.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They can select the trump color in the beginning of the game.
class RoleB extends Role {
  /// Creates a [RoleB].
  RoleB() : super(key: RoleCatalog.roleB);

  @override
  bool onStartOfSubgame(Game game) {
    game.inputRequirement = InputRequirement.selectTrump;
    return true;
  }

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
