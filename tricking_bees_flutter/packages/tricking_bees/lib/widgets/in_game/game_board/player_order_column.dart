import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_ui/flutter_game_framework_ui.dart';
import 'package:tb_core/tb_core.dart';

/// A display for the current player order.
class PlayerOrderColumn extends StatelessWidget {
  /// Creates a [PlayerOrderColumn].
  const PlayerOrderColumn({
    super.key,
    required this.game,
  });

  /// The game for which to display the player order
  final TBGame game;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...game.playOrder
              .map(
            (i) => [
              const Icon(Icons.arrow_downward),
              Padding(
                padding: const EdgeInsets.all(2),
                child: PlayerIcon(
                  index: i,
                  tooltip: game.players[i].displayName,
                  isHighlighted: game.currentPlayerIndex == i,
                ),
              ),
            ],
          )
              .fold([], (v1, v2) => [...v1, ...v2]),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TBGame>('game', game));
  }
}
