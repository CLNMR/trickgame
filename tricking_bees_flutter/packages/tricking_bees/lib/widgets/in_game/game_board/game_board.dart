import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../single_card_display.dart';

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
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              child: FractionallySizedBox(
                heightFactor: 0.7,
                widthFactor: 0.5,
                child: _buildPlayArea(),
              ),
            ),
          ],
        ),
      );

  Widget _buildPlayArea() => Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: widget.game.currentTrick != null
                ? _buildTrickGrid()
                : const SizedBox(),
          ),
        ),
      );

  Widget _buildTrickGrid() => Stack(
        children: widget.game.currentTrick!.cardMap.entries
            .toList()
            .asMap()
            .entries
            .map((entry) {
          const offset = 50.0;
          return Positioned(
            left: entry.key * offset / 2,
            top: entry.key * offset,
            child: _buildWrappedCardDisplay(
              entry.value.key,
              widget.game.players[entry.value.value],
            ),
          );
        }).toList(),
      );

  Widget _buildWrappedCardDisplay(GameCard card, Player player) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 150),
        child: Stack(
          children: [
            SingleCardDisplay(cardKey: card),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      player.displayName,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
