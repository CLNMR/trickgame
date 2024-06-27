import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

/// A small icon representing the player in the normal order.
class PlayerIcon extends StatelessWidget {
  /// Creates a [PlayerIcon].
  const PlayerIcon({super.key, required this.index, this.tooltip});

  /// The player index of this player.
  final PlayerIndex index;

  /// A tooltip to be displayed.
  final String? tooltip;

  /// The catalog entry corresponding to this player
  PlayerOrderCatalog get player => PlayerOrderCatalog.fromIndex(index);

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip ?? '',
        child: Container(
          decoration: BoxDecoration(
            color: player.color,
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(
              Radius.elliptical(3, 1),
            ),
          ),
          padding: const EdgeInsets.all(3),
          child: Text(
            player.playerLetter,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('index', index))
      ..add(EnumProperty<PlayerOrderCatalog>('player', player))
      ..add(StringProperty('tooltip', tooltip));
  }
}

/// A catalog to display players.
enum PlayerOrderCatalog {
  player1(Color.fromRGBO(255, 130, 143, 1)),
  player2(Color.fromRGBO(146, 206, 255, 1)),
  player3(Color.fromRGBO(139, 195, 74, 1)),
  player4(Color.fromRGBO(175, 129, 207, 1)),
  player5(Color.fromRGBO(255, 245, 152, 1)),
  player6(Color.fromRGBO(255, 172, 99, 1));

  const PlayerOrderCatalog(this.color);

  /// Get the [PlayerOrderCatalog] corresponding to the given index.
  factory PlayerOrderCatalog.fromIndex(PlayerIndex index) => values[index];

  /// The color associated with this player.
  final Color color;

  /// The letter associated with this player.
  String get playerLetter => ['A', 'B', 'C', 'D', 'E', 'F'][index];

  /// Get all players for a given player number.
  static Iterable<PlayerOrderCatalog> getPlayers(int playerNum) =>
      values.sublist(0, playerNum);
}
