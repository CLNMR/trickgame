import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../widgets/own_button.dart';
import '../../widgets/own_counter.dart';
import '../../widgets/own_text.dart';

/// The display screen of the bidding.
class WaitingDisplay extends ConsumerStatefulWidget {
  /// Creates a [WaitingDisplay].
  const WaitingDisplay({super.key, required this.game});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WaitingDisplayState();

  /// The id of the game to show.
  final Game game;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}

class _WaitingDisplayState extends ConsumerState<WaitingDisplay> {
  bool _shufflePlayers = false;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const OwnText(text: 'Waiting for players...'),
            SelectableText(widget.game.gameId.toString()),
            SelectableText(widget.game.id),
            _buildPlayerNumSelection(),
            _buildPlayerListDisplay(),
            _buildShuffleCheckbox(),
            _buildStartGameButton(),
            ElevatedButton(
              onPressed: _addPlayer,
              child: const Text('Add new default player'),
            ),
          ],
        ),
      );

  Widget _buildPlayerNumSelection() => Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white.withAlpha(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 120, child: Text('# of players:')),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: OwnCounter(
                      initialVal: 4,
                      minVal: 3,
                      maxVal: 6,
                      isEditable: false,
                      onChanged: (value) async {
                        widget.game.playerNum = value;
                        await widget.game.save();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white.withAlpha(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 120, child: Text('# of subgames:')),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: OwnCounter(
                      initialVal: 4,
                      minVal: 1,
                      maxVal: 100,
                      onChanged: (value) async {
                        widget.game.subgameNum = value;
                        await widget.game.save();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add more Rows for more OwnCounters
        ],
      );

  Widget _buildShuffleCheckbox() => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.white.withAlpha(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 120, child: Text('Shuffle players:')),
              Checkbox(
                value: _shufflePlayers,
                onChanged: (value) {
                  setState(() {
                    _shufflePlayers = value!;
                  });
                },
              ),
            ],
          ),
        ),
      );
  Widget _buildPlayerListDisplay() => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.white.withAlpha(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 120, child: Text('Players:')),
              ...widget.game.players.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white.withAlpha(100),
                    ),
                    child: Text(e.displayName),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildStartGameButton() => OwnButton(
        text: 'StartGame',
        icon: widget.game.arePlayersComplete()
            ? Icons.arrow_circle_right_outlined
            : null,
        onPressed: () async => widget.game.arePlayersComplete()
            ? widget.game.startNewSubgame()
            : null,
      );

  Future<void> _addPlayer() async {
    if (widget.game.players.length >= widget.game.playerNum) return;
    var playerIndex = widget.game.players.length + 1;
    final playerDict = {
      1: 't3IVfYdUmEO0t0HjY3jyYpG18a62',
      2: 'g43KiJIKjpMDWhJtIdQ4OjgOsWF2',
      3: 'KQASBKb7IAOgPIzjHIeuOcPoWmK2',
      4: 'zuFs7ee4QlTJPtERiwngaDpsxtA3',
      5: 'Y0XHPt86PBdaarII10oe2YcG7ef1',
    };
    while (widget.game.players
        .any((element) => element.id == playerDict[playerIndex])) {
      playerIndex += 1;
      if (!playerDict.containsKey(playerIndex)) return;
    }
    await widget.game.addPlayer(
      Player(
        id: playerDict[playerIndex]!,
        displayName: 'Player $playerIndex',
      ),
    );
  }
}
