import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_game_framework_ui/flutter_game_framework_ui.dart';
import 'package:tb_core/tb_core.dart';

/// Display the currently active event, the round and whose turn it is.
class EventAndRoundInfo extends StatelessWidget {
  /// Creates a [EventAndRoundInfo].
  const EventAndRoundInfo({super.key, required this.game});

  /// The game to show.
  final TBGame game;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          OwnText(
            trObject: TrObject(
              'RoundDisplay',
              args: [game.currentRound.toString()],
            ),
          ),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}
