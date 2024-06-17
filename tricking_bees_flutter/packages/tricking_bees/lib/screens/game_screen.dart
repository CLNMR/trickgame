import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';
import 'package:yust_ui/yust_ui.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/in_game/game_board/game_board_in_progress_display.dart';
import 'game_display/end_display.dart';
import 'game_display/in_game_display.dart';
import 'game_display/role_selection_display.dart';
import 'game_display/waiting_display.dart';

/// The game screen of the app.
@Screen(param: 'gameId')
class GameScreen extends ConsumerStatefulWidget {
  /// Creates a [GameScreen].
  const GameScreen({super.key, required this.gameId});

  /// The id of the game to show.
  final String gameId;

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('gameId', gameId));
  }
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late Game statefulGame;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('TrickingBees'),
          actions: useAuth ? null : _changeStateButtons(),
          backgroundColor: Colors.black26,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: YustDocBuilder(
            modelSetup: Game.setup(),
            id: widget.gameId,
            builder: (game, insights, context) {
              if (game == null) {
                return const Center(
                  child: Text('Game not found'),
                );
              } else {
                statefulGame = game;
                switch (game.gameState) {
                  case GameState.waitingForPlayers:
                    return WaitingDisplay(game: game);
                  case GameState.roleSelection:
                    return InGameDisplay(
                      game: game,
                      child: RoleSelectionDisplay(game: game),
                    );
                  case GameState.inProgress:
                    return InGameDisplay(
                      game: game,
                      child: GameBoardInProgressDisplay(game: game),
                    );
                  case GameState.finished:
                    return InGameDisplay(
                      game: game,
                      child: EndDisplay(game: game),
                    );
                }
              }
            },
          ),
        ),
      );

  List<Widget> _changeStateButtons() => GameState.values
      .map(
        (state) => IconButton(
          icon: Icon(
            IconData(state.iconCodePoint, fontFamily: 'MaterialIcons'),
          ),
          onPressed: () async {
            statefulGame.gameState = state;
            // Reset the game if we try to set it in progress.
            if (state == GameState.inProgress) {
              statefulGame
                ..currentRound = 0
                ..logEntries.forEach((key, value) {
                  if (key != 0) value.clear();
                });
              await statefulGame.nextPlayer();
            }
            await statefulGame.save();
          },
        ),
      )
      .toList();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('statefulGame', statefulGame));
  }
}
