import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../util/app_gradients.dart';
import '../../util/context_extension.dart';
import '../../util/widget_ref_extension.dart';
import '../../widgets/in_game/player_information/player_icon.dart';
import '../../widgets/in_game/player_information/player_instructions_row.dart';
import '../../widgets/own_button.dart';
import '../../widgets/own_text.dart';

/// The display screen of the bidding.
class WaitingDisplay extends ConsumerStatefulWidget {
  /// Creates a [WaitingDisplay].
  const WaitingDisplay({super.key, required this.game});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WaitingDisplayState();

  /// The game to show.
  final Game game;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}

class _WaitingDisplayState extends ConsumerState<WaitingDisplay> {
  bool get _canShufflePlayers {
    final game = widget.game;
    return !game.shufflePlayers &&
        game.isUserOwner(ref.user) &&
        game.players.length > 1;
  }

  bool canDeletePlayer(int playerIndex) {
    final game = widget.game;
    return game.isUserOwner(ref.user) &&
        0 <= playerIndex &&
        playerIndex < game.players.length &&
        game.players[playerIndex].id != ref.user?.id;
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildGameInformation(),
            const Spacer(),
            if (widget.game.isUserOwner(ref.user) &&
                widget.game.arePlayersComplete)
              _buildStartGameButton(),
            PlayerInstructionsRow(game: widget.game),
            if (noAuth)
              ElevatedButton(
                onPressed: _addPlayer,
                child: const Text('Add new default player'),
              ),
          ],
        ),
      );

  Widget _buildGameInformation() => Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5),
          gradient: AppGradients.indigoToYellow,
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: OwnText(
                text: 'WAITING:gameInformationHeader',
                type: OwnTextType.subtitle,
              ),
            ),
            const Divider(
              height: 2,
              thickness: 2,
            ),
            Row(
              children: [
                const OwnText(text: 'NEWGAME:gameIdHeader'),
                const SizedBox(width: 5),
                Expanded(
                  child: SelectableText(
                    widget.game.gameId.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (noAuth) SelectableText(widget.game.id),
            _buildPlayerListDisplay(),
            RichText(
              text: context.trFromObjectToTextSpan(
                TrObject(
                  'WAITING:subgameNumInfo',
                  richTrObjects: [
                    RichTrObject(
                      RichTrType.number,
                      value: widget.game.subgameNum,
                    ),
                  ],
                ),
                [],
              ),
            ),
          ],
        ),
      );

  Widget _buildPlayerListDisplay() => Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(3),
        ),
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            Row(
              children: [
                const OwnText(text: 'WAITING:playersHeader'),
                Expanded(
                  child: _canShufflePlayers
                      ? _buildReorderablePlayers()
                      : _buildAvailablePlayers(),
                ),
                const SizedBox(width: 5),
                const OwnText(text: 'WAITING:connectiveOf'),
                const SizedBox(width: 5),
                PlayerIcon(
                  index: widget.game.playerNum - 1,
                  displayNumber: true,
                ),
              ],
            ),
            if (widget.game.shufflePlayers)
              const OwnText(text: 'WAITING:shufflePlayers'),
          ],
        ),
      );

  Widget _buildAvailablePlayers() => Row(
        children: widget.game.players
            .asMap()
            .entries
            .map(
              (e) => Flexible(
                child: _buildSinglePlayerIcon(e.key, e.value.displayName),
              ),
            )
            .toList(),
      );

  Widget _buildSinglePlayerIcon(
    int playerIndex,
    String displayName, {
    Widget? trailing,
  }) =>
      Container(
        padding: const EdgeInsets.all(3),
        constraints: BoxConstraints(
          maxWidth: _canShufflePlayers ? double.infinity : 100,
        ),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          children: [
            PlayerIcon(index: widget.game.shufflePlayers ? 6 : playerIndex),
            const SizedBox(width: 3),
            OwnText(
              text: displayName,
              translate: false,
              ellipsis: true,
            ),
            if (trailing != null) ...[
              const Spacer(),
              trailing,
              const SizedBox(width: 25),
            ],
          ],
        ),
      );

  Widget _buildReorderablePlayers() => ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onReorder: _canShufflePlayers
            ? (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final player = widget.game.players.removeAt(oldIndex);
                  widget.game.players.insert(newIndex, player);
                });
              }
            : (_, __) {},
        children: widget.game.players
            .asMap()
            .entries
            .map(
              (e) => ReorderableDragStartListener(
                key: ValueKey(e.value),
                index: e.key,
                child: _buildSinglePlayerIcon(
                  e.key,
                  e.value.displayName,
                  trailing: _removePlayerButton(e.key),
                ),
              ),
            )
            .toList(),
      );

  /// A small button to remove a player.
  Widget _removePlayerButton(int playerIndex) {
    final canDelete = canDeletePlayer(playerIndex);
    return widget.game.isUserOwner(ref.user)
        ? Tooltip(
            message:
                'WAITING:removePlayerTooltip${canDelete ? '' : 'Disabled'}',
            child: IconButton(
              icon: Icon(
                Icons.remove_circle,
                color: canDelete ? Colors.red[900] : Colors.grey,
              ),
              onPressed: canDelete
                  ? () async => widget.game.removePlayer(playerIndex)
                  : null,
            ),
          )
        : const SizedBox();
  }

  Widget _buildStartGameButton() => OwnButton(
        text: 'StartGame',
        icon: widget.game.arePlayersComplete
            ? Icons.arrow_circle_right_outlined
            : null,
        onPressed: () async =>
            widget.game.arePlayersComplete ? widget.game.startMainGame() : null,
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
    await widget.game.tryAddPlayer(
      Player(
        id: playerDict[playerIndex]!,
        displayName: 'Player $playerIndex',
      ),
    );
  }
}
