import '../cards/card_color.dart';
import '../cards/card_stack.dart';
import '../models/game/tb_game.dart';
import 'role.dart';
import 'role_catalog.dart';

/// Always able to play any card of their choice.
class RoleE extends Role {
  /// Creates a [RoleE].
  RoleE() : super(key: RoleCatalog.roleE);

  @override
  CardStack getPlayableCards(CardStack hand, CardColor? compulsoryColor) =>
      hand;

  @override
  int calculatePoints(TBGame game, int tricksWon) => tricksWon;
}
