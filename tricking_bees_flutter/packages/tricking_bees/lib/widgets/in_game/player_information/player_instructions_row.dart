import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_ui/flutter_game_framework_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

/// The widget giving the player instructions during the game.
class PlayerInstructionsRow extends ConsumerWidget {
  /// Creates a [PlayerInstructionsRow].
  const PlayerInstructionsRow({super.key, required this.game});

  /// The game to show.
  final TBGame game;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TBGame>('game', game));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: SizedBox(
            height: 14 * 1.2 * 3, // Font size * line height * max lines
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: game
                    .getStatusMessages(ref.user)
                    .map(
                      (msg) => context.trFromObjectToTextSpan(
                        msg,
                        game.shortenedPlayerNames,
                      ),
                    )
                    .expand((span) => [span, const TextSpan(text: '\n ')])
                    .toList()
                  ..removeLast(),
              ),
              maxLines: 3,
            ),
          ),
        ),
      );
}
