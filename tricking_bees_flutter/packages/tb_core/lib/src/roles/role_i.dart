import 'dart:math';

import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:yust/yust.dart';

import '../cards/card_color.dart';
import '../models/game/tb_game.dart';
import '../util/tb_rich_tr_object_type.dart';
import 'role.dart';
import 'role_catalog.dart';

/// None of their cards is trump, and they desire to score as little as
/// possible.
class RoleI extends Role {
  /// Creates a [RoleI].
  RoleI() : super(key: RoleCatalog.roleI);

  @override
  int calculatePoints(TBGame game, int tricksWon) => max(0, 8 - tricksWon * 2);

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
