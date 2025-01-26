import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_game_framework_ui/flutter_game_framework_ui.dart';
import 'package:tb_core/tb_core.dart';

import '../../single_card_display.dart';

/// A widget to display a given trick.
class TrickDisplay extends StatelessWidget {
  /// Creates a [TrickDisplay].
  TrickDisplay(
    this.trick, {
    super.key,
    List<PlayerIndex>? hiddenPlayers,
    this.winningCard,
    this.maxCardHeight = 150,
    required this.playerNames,
  }) : hiddenPlayers = hiddenPlayers ?? [];

  /// The trick to display.
  final Trick trick;

  /// The playerIndices of players that play their cards hidden.
  final List<PlayerIndex> hiddenPlayers;

  /// The card that won the trick (if any).
  final GameCard? winningCard;

  /// The maximum height a card should have.
  final double maxCardHeight;

  /// The list of players names.
  final List<String> playerNames;

  @override
  Widget build(BuildContext context) => Stack(
        children: trick.enumeratedCards.entries.map((e) {
          // Scale the offset down with higher amounts of cards
          final offset = 2 * maxCardHeight / max(trick.length + 1, 6);
          return Positioned(
            left: e.key * offset,
            top: e.key * offset,
            child: _buildWrappedCardDisplay(
              e.value.key,
              e.value.value,
              isHighlighted: e.value.key == winningCard,
            ),
          );
        }).toList(),
      );

  Widget _buildWrappedCardDisplay(
    GameCard card,
    PlayerIndex playerIndex, {
    bool isHighlighted = false,
  }) =>
      Container(
        decoration: isHighlighted
            ? BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(2),
              )
            : null,
        padding: EdgeInsets.zero, // Needed in order to let the decoration know
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxCardHeight),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              SingleCardDisplay.fromCardKey(
                cardKey: card,
                isHidden: trick.cardMap.keys.first != card &&
                    hiddenPlayers.contains(playerIndex),
              ),
              Positioned(
                top: 3,
                right: 3,
                child: PlayerIcon(
                  index: playerIndex,
                  tooltip: playerNames[playerIndex],
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Trick>('trick', trick))
      ..add(DiagnosticsProperty<GameCard?>('winningCard', winningCard))
      ..add(IterableProperty<String>('playerNames', playerNames))
      ..add(DoubleProperty('maxCardHeight', maxCardHeight))
      ..add(IterableProperty<PlayerIndex>('hiddenPlayers', hiddenPlayers));
  }
}
