import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../widgets/in_game/game_board/game_board.dart';

/// The display screen of the bidding.
class EndDisplay extends ConsumerWidget {
  /// Creates a [EndDisplay].
  const EndDisplay({super.key, required this.game});

  /// The game to show.
  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) => GameBoard(
        game: game,
        handleCardTap: (_) {},
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}
