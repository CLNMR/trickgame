import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../util/widget_ref_extension.dart';
import '../../widgets/in_game/log_entry_list_display.dart';
import '../../widgets/in_game/player_information/player_cards_row.dart';
import '../../widgets/in_game/player_information/player_info_widget.dart';
import '../../widgets/in_game/player_information/player_instructions_row.dart';
import '../../widgets/own_button.dart';
import '../../widgets/own_text.dart';

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
    lastLogDisplayed = widget.game.getLogEntriesFlattened().length;
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
    final allLogEntries = widget.game.getLogEntriesFlattened();
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
          if (constraints.maxHeight > constraints.maxWidth) {
            return Column(
              children: [
                PlayerInfoWidget(game: widget.game),
                Expanded(child: _buildBoardAndLog(ref)),
                PlayerInstructionsRow(game: widget.game),
                PlayerCardsRow(game: widget.game),
              ],
            );
          }
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    PlayerInfoWidget(game: widget.game, asColumn: true),
                    Expanded(child: _buildBoardAndLog(ref)),
                  ],
                ),
              ),
              PlayerInstructionsRow(game: widget.game),
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
                // if (_controller.value > 0) _buildEventDisplay(),
                // if (showEventDisplay) _buildEventDisplay(),
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
