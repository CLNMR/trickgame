import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';

import '../../tb_core.dart';
import 'custom_types.dart';

/// The special translation type for a TrObject.
class TBRichTrType {
  /// The list of all custom rich translation types.
  static List<RichTrType> tbRichTrTypes = [
    card,
    cardList,
    role,
    playerRanking,
    color,
  ];

  /// Display a game card.
  static const card = RichTrType('card', GameCard);

  /// Display a list of game cards.
  static const cardList = RichTrType('cardList', CardStack);

  /// The special translation type for a game event.
  static const role = RichTrType('role', RoleCatalog);

  /// The special translation type for a list of players.
  static const playerRanking =
      RichTrType('playerRanking', Map<PlayerRank, List<PlayerIndex>>);

  /// The special translation type for a color.
  static const color = RichTrType('color', CardColor);
}
