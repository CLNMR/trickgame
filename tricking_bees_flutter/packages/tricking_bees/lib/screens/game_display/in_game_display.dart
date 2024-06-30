import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../util/app_gradients.dart';
import '../../util/context_extension.dart';
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
  bool _skipIsHovered = false;
  @override
  Widget build(BuildContext context) {
    final player = widget.game.getPlayer(ref.user!);
    return Center(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: _buildBoardAndPlayers(),
                    ),
                  ),
                ),
                PlayerInstructionsRow(game: widget.game),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlayerInfoDisplay(
                      game: widget.game,
                      player: player,
                      hasCurrentTurn: widget.game.currentPlayer.id == player.id,
                    ),
                    _buildSkipButton(),
                    Flexible(
                      child: PlayerCardsRow(
                        game: widget.game,
                        player: widget.game.getPlayer(ref.user!),
                      ),
                    ),
                    _buildTrumpDisplay(),
                  ],
                ),
              ],
            ),
          ),
          _buildLog(),
        ],
      ),
    );
  }

  Widget _buildSkipButton() => ref.user != null &&
          widget.game.getPlayer(ref.user!).role.canSkipTurn
      ? Tooltip(
          message: 'BUTTON:SkipCardPlay'.tr(),
          child: Container(
            height: 100,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(),
              gradient: AppGradients.indigoToYellow,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  bottom: 10,
                  child: Transform.scale(
                    scale: _skipIsHovered ? 1.15 : 1.0,
                    child: MouseRegion(
                      onEnter: (event) => setState(() => _skipIsHovered = true),
                      onExit: (event) => setState(() => _skipIsHovered = false),
                      child: Transform.rotate(
                        angle: -0.02,
                        child: SingleCardDisplay(
                          cardColor: Colors.grey,
                          symbol: 'X',
                          isDisabled: !widget.game.canSkipTurn(ref.user),
                          onTap: () async => widget.game.skipCardPlay(ref.user),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      : const SizedBox();

  Widget _buildLog() => Container(
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
              if (noAuth) SelectableText(widget.game.id),
              if (noAuth)
                Tooltip(
                  message: widget.game.flags.toString(),
                  child: Text(widget.game.inputRequirement.toString()),
                ),
              if (noAuth)
                OwnButton(
                  text: 'ProceedRandomly',
                  onPressed: () async {
                    await widget.game.performRandomPossibleAction();
                  },
                ),
            ],
          ),
        ),
      );

  Widget _buildTrumpDisplay() => Tooltip(
        richMessage: context.trFromObjectToTextSpan(
          TrObject(
            'trumpDisplayTooltip',
            richTrObjects: [
              RichTrObject(
                RichTrType.color,
                value: widget.game.currentTrumpColor ?? CardColor.noColor,
              ),
            ],
          ),
          [],
        ),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white.withOpacity(0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                const OwnText(text: 'HEAD:trumpDisplay'),
                Expanded(
                  child: Row(
                    children: [
                      if (widget.game.currentTrump != null)
                        SingleCardDisplay.fromCardKey(
                          cardKey: widget.game.currentTrump!,
                          isDisabled: widget.game.hasOverridingTrumpColor,
                        )
                      else
                        const SingleCardDisplay(
                          cardColor: Colors.black,
                          symbol: '!',
                        ),
                      if (widget.game.hasOverridingTrumpColor)
                        SingleCardDisplay(
                          cardColor:
                              Color(widget.game.currentTrumpColor!.hexValue),
                          symbol: '!',
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  // return AnimatedBuilder(
  //   animation: _controller,
  //   builder: (context, child) =>
  Widget _buildBoardAndPlayers() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildPlayersInTopRow(),
          Expanded(
            child: Row(
              children: [
                _buildLeftPlayer(),
                Expanded(child: _buildGameArea()),
                _buildRightPlayer(),
              ],
            ),
          ),
        ],
      );

  /// The actual game area.
  Widget _buildGameArea() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          gradient: AppGradients.indigoToYellow,
        ),
        padding: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: widget.child,
        ),
      );

  Widget _buildPlayersInTopRow() {
    final otherPlayers = widget.game.getOtherPlayers(ref.user);
    if (widget.game.playerNum != 3) {
      otherPlayers
        ..removeAt(0)
        ..removeLast();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: otherPlayers.map(_buildPlayerOverlay).toList(),
    );
  }

  Widget _buildLeftPlayer() => (widget.game.playerNum == 3)
      ? Container()
      : Column(
          children: [
            _buildPlayerOverlay(
              widget.game.getOtherPlayers(ref.user)[0],
              rotation: 1,
            ),
          ],
        );
  Widget _buildRightPlayer() => (widget.game.playerNum == 3)
      ? Container()
      : Column(
          children: [
            _buildPlayerOverlay(
              widget.game.getOtherPlayers(ref.user).last,
              rotation: 3,
            ),
          ],
        );

  Widget _buildPlayerOverlay(
    Player player, {
    int rotation = 2,
  }) =>
      Flexible(
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: rotation != 2
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PlayerInfoDisplay(
                      game: widget.game,
                      player: player,
                      hasCurrentTurn: player.id == widget.game.currentPlayer.id,
                    ),
                    Flexible(child: _buildPlayerCards(player, rotation)),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlayerInfoDisplay(
                      game: widget.game,
                      player: player,
                      hasCurrentTurn: widget.game.currentPlayer.id == player.id,
                    ),
                    Flexible(child: _buildPlayerCards(player, rotation)),
                  ],
                ),
        ),
      );

  Widget _buildPlayerCards(Player player, int rotation) => RotatedBox(
        quarterTurns: rotation,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: rotation == 2 ? 100 : 120,
            maxWidth: 200,
          ),
          child: PlayerCardsRow(
            game: widget.game,
            player: player,
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', widget.game));
  }
}
