import '../cards/card_color.dart';
import '../cards/card_stack.dart';
import '../cards/game_card.dart';
import '../roles/role_catalog.dart';
import '../util/custom_types.dart';

/// The special translation type for a TrObject.
enum RichTrType {
  /// The default style.
  none(String),

  /// Display a game card.
  card(GameCard),

  /// Display a list of game cards.
  cardList(CardStack),

  /// The special translation type for a game event.
  role(RoleCatalog),

  /// The special translation type for a player.
  player(PlayerIndex),

  /// The special translation type for a list of players.
  playerList(List<PlayerIndex>),

  /// The special translation type for a list of players.
  playerRanking(Map<PlayerRank, List<PlayerIndex>>),

  /// The special translation type for a number.
  number(int),

  /// The special translation type for a number with a + or - operator.
  numberWithOperator(int),

  /// The special translation type for a color.
  color(CardColor);

  const RichTrType(this.valueType);

  /// The type of the value associated with this.
  final Type valueType;
}
