import '../cards/game_card.dart';
import '../roles/role_catalog.dart';

/// The special translation type for a TrObject.
enum RichTrType {
  /// The default style.
  none(String),

  /// Display a game card.
  card(GameCard),

  /// Display a list of game cards.
  cardList(List<GameCard>),

  /// The special translation type for a game event.
  role(RoleCatalog),

  /// The special translation type for a player.
  player(int),

  /// The special translation type for a list of players.
  playerList(List<int>),

  /// The special translation type for a number.
  number(int),

  /// The special translation type for a number with a + or - operator.
  numberWithOperator(int);

  const RichTrType(this.valueType);

  /// The type of the value associated with this.
  final Type valueType;
}
