import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

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
            const Text('Waiting for players...'),
            SelectableText(game.gameId.toString()),
            SelectableText(game.id),
            Text(
              'Players: ${game.playerIds.map((e) => e.displayName).join(', ')}',
            ),
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

  Future<void> _addPlayer1() async {
    await game.addPlayer(
      const PlayerId(
        id: 'I0trfXICcqPgwUCoPAvBwujj4bw2',
        displayName: 'TestPlayer 1',
      ),
    );
  }

  Future<void> _addPlayer2() async {
    await game.addPlayer(
      const PlayerId(
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
