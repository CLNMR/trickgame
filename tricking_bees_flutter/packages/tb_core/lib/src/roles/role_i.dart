import 'dart:math';

import '../models/game/game.dart';
import 'role.dart';
import 'role_catalog.dart';

/// None of their cards is trump, and they desire to score as little as
/// possible.
class RoleI extends Role {
  /// Creates a [RoleI].
  RoleI() : super(key: RoleCatalog.roleI);

  @override
  int calculatePoints(Game game, int tricksWon) => max(0, 8 - tricksWon * 2);
}
