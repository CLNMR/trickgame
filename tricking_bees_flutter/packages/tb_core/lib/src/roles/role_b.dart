import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:yust/yust.dart';

import '../cards/card_color.dart';
import '../models/game/tb_game.dart';
import '../util/tb_rich_tr_object_type.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They can select the trump color in the beginning of the game.
class RoleB extends Role {
  /// Creates a [RoleB].
  RoleB() : super(key: RoleCatalog.roleB);

  @override
  bool onStartOfSubgame(TBGame game) {
    game.inputRequirement = InputRequirement.selectTrump;
    return true;
  }

  @override
  TrObject getStatusWhileActive(TBGame game, YustUser? user) => TrObject(
        key.statusKey,
        richTrObjects: [
          RichTrObject(
            TBRichTrType.color,
            value: game.currentTrumpColor ?? CardColor.noColor,
          ),
        ],
      );
}
