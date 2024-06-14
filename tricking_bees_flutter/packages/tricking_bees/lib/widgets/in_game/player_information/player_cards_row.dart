import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../../util/widget_ref_extension.dart';
import '../card_grid_view.dart';

/// The widget displaying a player's remaining cards, and offering a skip turn
/// button if they cannot move.
class PlayerCardsRow extends ConsumerStatefulWidget {
  /// Creates a [PlayerCardsRow].
  const PlayerCardsRow({super.key, required this.game});

  /// The game to show.
  final Game game;

  @override
  ConsumerState<PlayerCardsRow> createState() => _PlayerCardsRowState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}

class _PlayerCardsRowState extends ConsumerState<PlayerCardsRow> {
  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.black),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[600]!, Colors.indigo[900]!],
          ),
        ),
        child: Center(
          child: _buildPlayerCards(),
        ),
      );

  Widget _buildPlayerCards() => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 130),
        child: CardGridView(
          cards: sortCardsList(widget.game.getRemainingHandCards(ref.user)),
          isDisabled: !widget.game.canPlayAnyCards(ref.user),
          onTap: (card) async {
            await widget.game.playCard(card, ref.user);
          },
        ),
      );
}
