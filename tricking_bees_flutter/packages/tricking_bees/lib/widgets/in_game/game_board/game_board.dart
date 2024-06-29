import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../own_text.dart';
import 'player_order_column.dart';
import 'trick_display.dart';

/// The area displaying the currently displayed tricks.
class GameBoard extends ConsumerWidget {
  /// Creates a [GameBoard].
  const GameBoard({
    super.key,
    required this.game,
  });

  /// The game to be displayed.
  final Game game;

  /// The display names of the players.
  List<String> get playerNames =>
      game.players.map((e) => e.displayName).toList();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Game>('game', game))
      ..add(IterableProperty<String>('playerNames', playerNames));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => game.currentTrick != null
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (game.previousTrick != null) ...[
              Flexible(child: _buildPreviousTrickGrid()),
              const SizedBox(width: 5),
            ],
            Flexible(
              flex: 2,
              child: _buildCurrentTrickGrid(),
            ),
            const SizedBox(width: 5),
            PlayerOrderColumn(game: game),
          ],
        )
      : const SizedBox();

  Widget _buildPreviousTrickGrid() {
    final previousTrick = game.previousTrick!;
    final winningCard = previousTrick.getWinningCard(game.currentTrumpColor);
    return _ContainerWithHeading(
      headingKey: 'GAMEUI:previousTrick',
      child: TrickDisplay(
        previousTrick,
        winningCard: winningCard,
        playerNames: playerNames,
        maxCardHeight: 80,
      ),
    );
  }

  Widget _buildCurrentTrickGrid() => _ContainerWithHeading(
        headingKey: 'GAMEUI:currentTrick',
        child: TrickDisplay(
          game.currentTrick!,
          playerNames: playerNames,
          hiddenPlayers: game.players
              .asMap()
              .entries
              .where((e) => e.value.role.playsCardHidden)
              .map((e) => e.key)
              .toList(),
        ),
      );
}

/// A plain container with a heading.
class _ContainerWithHeading extends StatelessWidget {
  const _ContainerWithHeading({
    required this.headingKey,
    required this.child,
  });

  final String headingKey;

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            OwnText(text: headingKey),
            const Divider(
              color: Colors.black,
            ),
            Expanded(child: child),
          ],
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('headingKey', headingKey));
  }
}
