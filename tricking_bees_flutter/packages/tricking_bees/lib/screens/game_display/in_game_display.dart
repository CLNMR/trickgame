import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../util/widget_ref_extension.dart';
import '../../widgets/in_game/log_entry_list_display.dart';
import '../../widgets/in_game/player_information/player_cards_row.dart';
import '../../widgets/in_game/player_information/player_info_display.dart';
import '../../widgets/in_game/player_information/player_instructions_row.dart';
import '../../widgets/own_button.dart';
import '../../widgets/own_text.dart';
import '../../widgets/single_card_display.dart';

/// The display screen of a game that is in progress.
/// The child widget should usually contain the GameBoard, but can also contain
/// the card selection for the bidding phase.
class InGameDisplay extends ConsumerStatefulWidget {
  /// Creates a [InGameDisplay].
  const InGameDisplay({
    super.key,
    required this.game,
    required this.child,
  });

  /// The game for which the info is displayed.
  final Game game;

  /// The child widget that is displayed in the central position.
  final Widget child;

  @override
  ConsumerState<InGameDisplay> createState() => _GameDisplayState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}

class _GameDisplayState extends ConsumerState<InGameDisplay> {
  String hash = '';

  late int lastLogDisplayed;

  TrObject? title;
  TrObject? message;
  Image? image;
  Color color = Colors.white;

  bool showEventDisplay = false;

  // late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    lastLogDisplayed = widget.game.getLogEntries().length;
    // _controller = AnimationController(
    //   value: 0,
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // );
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allLogEntries = widget.game.getLogEntries();
    if (allLogEntries.length > lastLogDisplayed) {
      unawaited(
        allLogEntries[lastLogDisplayed].showEventDisplay(
          widget.game,
          _displayEventCallback,
          _incrementLastLogDisplayedCallback,
        ),
      );
    }
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final player = widget.game.getPlayer(ref.user!);
          if (constraints.maxHeight > constraints.maxWidth) {
            return Column(
              children: [
                Expanded(child: _buildBoardAndLog(ref)),
                Row(
                  children: [
                    PlayerInfoDisplay(
                      player: player,
                      hasCurrentTurn: widget.game.currentPlayer.id == player.id,
                    ),
                    Expanded(child: PlayerInstructionsRow(game: widget.game)),
                  ],
                ),
                PlayerCardsRow(game: widget.game),
              ],
            );
          }
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildBoardAndLog(ref)),
                  ],
                ),
              ),
              Row(
                children: [
                  PlayerInfoDisplay(
                    player: player,
                    hasCurrentTurn: widget.game.currentPlayer.id == player.id,
                  ),
                  Expanded(child: PlayerInstructionsRow(game: widget.game)),
                ],
              ),
              PlayerCardsRow(game: widget.game),
            ],
          );
        },
      ),
    );
  }

  // return AnimatedBuilder(
  //   animation: _controller,
  //   builder: (context, child) =>
  Widget _buildBoardAndLog(WidgetRef ref) => Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                widget.child,
                ..._buildPlayerOverlays(),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LogEntryListDisplay(game: widget.game),
                  ),
                  if (widget.game.canSkipTurn(ref.user))
                    OwnButton(
                      text: 'EndTurn',
                      onPressed: () async => widget.game.skipCardPlay(ref.user),
                    ),
                  if (!useAuth) SelectableText(widget.game.id),
                  if (!useAuth)
                    Tooltip(
                      message: widget.game.flags.toString(),
                      child: Text(widget.game.inputRequirement.toString()),
                    ),
                ],
              ),
            ),
          ),
        ],
      );

  Future<void> _displayEventCallback(
    TrObject t,
    TrObject m,
  ) async {
    title = t;
    message = m;

    showEventDisplay = true;
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));
    showEventDisplay = false;
    setState(() {});
    // print('2: ${DateTime.now()} ${t.text}');

    // await _controller.animateTo(0);
    // print('3: ${DateTime.now()} ${t.text}');
  }

  void _incrementLastLogDisplayedCallback() {
    lastLogDisplayed++;
    setState(() {});
  }

  Widget _buildEventDisplay() =>
      //  AnimatedBuilder(
      //       animation: _controller,
      //       builder: (context, child) =>
      Container(
        width: 300,
        height: 200,
        padding: const EdgeInsets.all(10),
        // color: color.withAlpha((_controller.value * 255).toInt()),
        color: color,
        child: Column(
          children: [
            OwnText(trObject: title, type: OwnTextType.title),
            if (image != null) image!,
            OwnText(trObject: message),
          ],
        ),
        // ),
      );

  List<Widget> _buildPlayerOverlays() {
    final players = widget.game.getOtherPlayers(ref.user);
    final playerNum = widget.game.playerNum;

    if (playerNum == 3) {
      return [
        _buildPlayerOverlay(players[0], Alignment.topLeft),
        _buildPlayerOverlay(players[1], Alignment.topRight),
      ];
    }

    if (playerNum == 4) {
      return [
        _buildPlayerOverlay(players[0], Alignment.centerLeft, vertical: true),
        _buildPlayerOverlay(players[1], Alignment.topCenter),
        _buildPlayerOverlay(players[2], Alignment.centerRight, vertical: true),
      ];
    }

    if (playerNum == 5) {
      return [
        _buildPlayerOverlay(players[0], Alignment.centerLeft, vertical: true),
        _buildPlayerOverlay(players[1], Alignment.topLeft),
        _buildPlayerOverlay(players[2], Alignment.topRight),
        _buildPlayerOverlay(players[3], Alignment.centerRight, vertical: true),
      ];
    }
    return [
      _buildPlayerOverlay(players[0], Alignment.centerLeft, vertical: true),
      _buildPlayerOverlay(players[1], Alignment.topLeft),
      _buildPlayerOverlay(players[2], Alignment.topCenter),
      _buildPlayerOverlay(players[3], Alignment.topRight),
      _buildPlayerOverlay(players[4], Alignment.centerRight, vertical: true),
    ];
  }

  Widget _buildPlayerOverlay(
    Player player,
    Alignment alignment, {
    bool vertical = false,
  }) =>
      Align(
        alignment: alignment,
        child: DecoratedBox(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: vertical
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlayerInfoDisplay(
                        player: player,
                        hasCurrentTurn:
                            player.id == widget.game.currentPlayer.id,
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: _buildPlayerCards(player),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlayerInfoDisplay(
                        player: player,
                        hasCurrentTurn:
                            widget.game.currentPlayer.id == player.id,
                      ),
                      _buildPlayerCards(player),
                    ],
                  ),
          ),
        ),
      );

  Widget _buildPlayerCards(Player player) => DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: SizedBox(
            width: 220,
            height: 150,
            child: Stack(
              children: player.cards
                  .asMap()
                  .entries
                  .map(
                    (e) => Positioned(
                      left: player.cards.length > 2
                          ? e.key * (200 / (player.cards.length + 1))
                          : e.key * 50,
                      child: SingleCardDisplay(
                        cardKey: e.value,
                        isHidden: false,
                        onTap: () async =>
                            widget.game.playOtherPlayerCard(e.value, player),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Game>('game', widget.game))
      ..add(StringProperty('hash', hash))
      ..add(IntProperty('lastLogDisplayed', lastLogDisplayed))
      ..add(DiagnosticsProperty<TrObject?>('title', title))
      ..add(DiagnosticsProperty<TrObject?>('message', message))
      ..add(ColorProperty('color', color))
      ..add(DiagnosticsProperty<bool>('showEventDisplay', showEventDisplay));
  }
}
