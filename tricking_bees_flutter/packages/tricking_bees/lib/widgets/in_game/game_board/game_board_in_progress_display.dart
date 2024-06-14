import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../own_button.dart';
import 'game_board.dart';

/// Display the game board during an ongoing game.
class GameBoardInProgressDisplay extends ConsumerStatefulWidget {
  /// Creates a [GameBoardInProgressDisplay].
  const GameBoardInProgressDisplay({super.key, required this.game});

  /// The game to show.
  final Game game;

  @override
  ConsumerState<GameBoardInProgressDisplay> createState() =>
      _GameBoardInProgressDisplayState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}

class _GameBoardInProgressDisplayState
    extends ConsumerState<GameBoardInProgressDisplay> {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          GameBoard(
            game: widget.game,
            handleCardTap: _handleCardTap,
          ),
          if (!useAuth)
            Align(
              alignment: Alignment.bottomLeft,
              child: OwnButton(
                text: 'Next player',
                onPressed: () async {
                  widget.game.inputRequirement = InputRequirement.card;
                  await widget.game.nextPlayer();
                },
              ),
            ),
          if (!useAuth)
            Align(
              alignment: Alignment.bottomRight,
              child: OwnButton(
                text: 'Skip HexTapPhase',
                onPressed: () async {
                  widget.game.inputRequirement = InputRequirement.card;
                  await widget.game.save();
                },
              ),
            ),
        ],
      );

  void _handleCardTap(Card card) {}
}
