import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../widgets/own_button.dart';
import '../../widgets/own_text.dart';

/// The display screen of the bidding.
class WaitingDisplay extends ConsumerWidget {
  /// Creates a [WaitingDisplay].
  const WaitingDisplay({super.key, required this.game});

  /// The id of the game to show.
  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const OwnText(text: 'Waiting for players...'),
            SelectableText(game.gameId.toString()),
            SelectableText(game.id),
            _buildPlayerNumSelection(),
            _buildPlayerListDisplay(),
            _buildStartGameButton(),
            ElevatedButton(
              onPressed: _addPlayer1,
              child: const Text('Add Default Player 1'),
            ),
            ElevatedButton(
              onPressed: _addPlayer2,
              child: const Text('Add Default Player 2'),
            ),
          ],
        ),
      );

  Widget _buildPlayerNumSelection() => Row(
        children: [], // TODO: Build box to select desired player number from,
        // TODO and box to select subgame number, and selectable roles.
      );

  Widget _buildPlayerListDisplay() => Row(
        children: game.players
            .map(
              (e) => DecoratedBox(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(3)),
                child: Text(e.displayName),
              ),
            )
            .toList(),
      );

  Widget _buildStartGameButton() => OwnButton(
        text: 'StartGame',
        onPressed: () async =>
            game.arePlayersComplete() ? game.startNewSubgame() : null,
      );

  Future<void> _addPlayer1() async {
    await game.addPlayer(
      Player(
        id: 'I0trfXICcqPgwUCoPAvBwujj4bw2',
        displayName: 'TestPlayer 1',
      ),
    );
  }

  Future<void> _addPlayer2() async {
    await game.addPlayer(
      Player(
        id: 'Ww9Av0uCbyUcFll5X0mib0Otvti1',
        displayName: 'TestPlayer 2',
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}
