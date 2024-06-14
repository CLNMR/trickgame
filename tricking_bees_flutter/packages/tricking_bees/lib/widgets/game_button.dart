import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_core/tb_core.dart';

import '../screens/game_screen.r.dart';
import '../util/widget_ref_extension.dart';
import 'own_button.dart';

/// A button that displays a summary of a game and leads to the game screen.
class GameButton extends ConsumerWidget {
  /// Creates a [GameButton].
  const GameButton({super.key, required this.game});

  /// The game to display.
  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.all(8),
        child: OwnButton(
          text: game.playerIds.map((player) => player.displayName).join(' - '),
          translate: false,
          onPressed: () async {
            final goRouter = GoRouter.of(context);
            await game.addUser(ref.user!);
            await goRouter.pushNamed(
              GameScreenRouting.path,
              pathParameters: {'gameId': game.id},
            );
          },
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}
