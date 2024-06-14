import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

/// The hexagonal board of the game.
class GameBoard extends ConsumerStatefulWidget {
  /// Creates a [GameBoard].
  const GameBoard({
    super.key,
    required this.game,
    required this.handleCardTap,
  });

  /// The game to be displayed.
  final Game game;

  /// What should happen if a hex is tapped.
  final Function(Card) handleCardTap;

  @override
  ConsumerState<GameBoard> createState() => _GameBoardState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Game>('game', game))
      ..add(
        ObjectFlagProperty<Function(Card p1)>.has(
          'handleCardTap',
          handleCardTap,
        ),
      );
  }
}

class _GameBoardState extends ConsumerState<GameBoard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => InteractiveViewer(
        minScale: 0.2,
        maxScale: 4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              child: FractionallySizedBox(
                heightFactor: 0.831,
                widthFactor: 0.831,
                child: _buildPlayArea(),
              ),
            ),
          ],
        ),
        // ),
      );

  Widget _buildPlayArea() => Center(child: Container());
}
