import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../../util/app_gradients.dart';
import '../../own_text.dart';
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
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: _buildPlayArea(),
        ),
      );

  Widget _buildPlayArea() => Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            gradient: AppGradients.indigoToYellow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: widget.game.currentTrick != null
                ? Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: _buildTrickGrid(),
                      ),
                      Flexible(child: _buildPreviousTrickGrid()),
                    ],
                  )
                : const SizedBox(),
          ),
        ),
      );

  Widget _buildTrickGrid() => Stack(
        children:
            widget.game.currentTrick!.enumeratedCards.entries.map((entry) {
          const offset = 35.0;
          return Positioned(
            left: entry.key * offset,
            top: entry.key * offset,
            child: _buildWrappedCardDisplay(
              entry.value.key,
              widget.game.players[entry.value.value],
            ),
          );
        }).toList(),
      );

  Widget _buildPreviousTrickGrid() {
    final previousTrick = widget.game.previousTrick;
    if (previousTrick == null) return const SizedBox();
    final winningCard =
        previousTrick.getWinningCard(widget.game.currentTrumpColor);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          const OwnText(text: 'PreviousTrick'),
          const Divider(
            color: Colors.black,
          ),
          Expanded(
            child: Stack(
              children: previousTrick.enumeratedCards.entries.map((e) {
                const offset = 20.0;
                return Positioned(
                  left: e.key * offset,
                  top: e.key * offset * 1.5,
                  child: _buildWrappedCardDisplay(
                    e.value.key,
                    widget.game.players[e.value.value],
                    maxHeight: 80,
                    isPrevious: true,
                    isHighlighted: e.value.key == winningCard,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWrappedCardDisplay(
    GameCard card,
    Player player, {
    double maxHeight = 150,
    bool isPrevious = false,
    bool isHighlighted = false,
  }) =>
      Container(
        decoration: isHighlighted
            ? BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              )
            : null,
        padding: EdgeInsets.zero, // Needed in order to let the decoration know
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              SingleCardDisplay.fromCardKey(
                cardKey: card,
                isHidden: !isPrevious && widget.game.playsCardHidden(player),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      player.displayName,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
