import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../single_card_display.dart';

/// The widget displaying a player's remaining cards, and offering a skip turn
/// button if they cannot move.
class PlayerCardsRow extends ConsumerStatefulWidget {
  /// Creates a [PlayerCardsRow].
  const PlayerCardsRow({super.key, required this.game, required this.player});

  /// The game to show.
  final Game game;

  /// The player whose cards to show.
  final Player player;

  @override
  ConsumerState<PlayerCardsRow> createState() => _PlayerCardsRowState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Game>('game', game))
      ..add(DiagnosticsProperty<Player>('player', player));
  }
}

class _PlayerCardsRowState extends ConsumerState<PlayerCardsRow> {
  int? _hoveredCardIndex;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 200,
            maxWidth: max(
              200,
              min(
                constraints.maxWidth,
                widget.player.cards.length.toDouble() * 60,
              ),
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.black),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigo[600]!.withOpacity(0.5),
                  Colors.yellow[50]!.withOpacity(0.5),
                ],
              ),
            ),
            child: Center(
              child: _buildPlayerCards(),
            ),
          ),
        ),
      );

  Widget _buildPlayerCards() => DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: SizedBox(
          height: 100,
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: getOrderedCards()
                  .map(
                    (e) => _buildPositionedCard(
                      e.$2,
                      e.$1,
                      constraints.maxWidth,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );

  List<(int, GameCard)> getOrderedCards() {
    final cardsMap = widget.player.cards
        .asMap()
        .entries
        .toList()
        .map((e) => (e.key, e.value))
        .toList();
    if ((_hoveredCardIndex ?? 0) >= cardsMap.length) _hoveredCardIndex = null;
    if (_hoveredCardIndex == null) return cardsMap;
    final hovered = cardsMap.removeAt(_hoveredCardIndex!);
    return cardsMap..add(hovered);
  }

  Widget _buildPositionedCard(GameCard card, int index, double maxWidth) {
    final leftOffset =
        (index + 0.5) * (maxWidth / (widget.player.cards.length + 2));
    return Positioned(
      // Use AnimatedPositioned for smooth animation; Doesn't seem to work with
      // the way I'm reordering the cards...
      // duration: const Duration(milliseconds: 300),
      left: leftOffset,
      top: 10,
      bottom: 10,
      child: MouseRegion(
        // Detect mouse hover
        onEnter: (event) => setState(() => _hoveredCardIndex = index),
        onExit: (event) => setState(() => _hoveredCardIndex = null),
        child: Transform.rotate(
          angle: Random(index).nextDouble() * 0.1 - 0.05,
          child: Transform.scale(
            // Scale up if hovered
            scale: _hoveredCardIndex == index ? 1.15 : 1.0,
            child: SingleCardDisplay(
              cardKey: card,
              isHidden: false,
              isDisabled: widget.player.id != widget.game.currentPlayer.id ||
                  !widget.player.canPlayCard(card, widget.game.compulsoryColor),
              onTap: () async =>
                  widget.game.playOtherPlayerCard(card, widget.player),
            ),
          ),
        ),
      ),
    );
  }
}
