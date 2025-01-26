import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:flutter_game_framework_ui/flutter_game_framework_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import 'role_icon.dart';

/// A small widget displaying the player's status.
class PlayerInfoDisplay extends ConsumerStatefulWidget {
  /// Creates a [PlayerInfoDisplay].
  const PlayerInfoDisplay({
    super.key,
    required this.game,
    required this.player,
    required this.hasCurrentTurn,
  });

  /// The game from which some extra info might be needed.
  final TBGame game;

  /// The player to display info for.
  final TBPlayer player;

  /// Whether the given player is currently required to input an action.
  final bool hasCurrentTurn;

  /// The current player's index.
  PlayerIndex get playerIndex => game.getPlayerIndex(player);

  @override
  ConsumerState<PlayerInfoDisplay> createState() => _PlayerInfoDisplayState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Player>('player', player))
      ..add(DiagnosticsProperty<bool>('hasCurrentTurn', hasCurrentTurn))
      ..add(DiagnosticsProperty<Game>('game', game))
      ..add(IntProperty('playerIndex', playerIndex));
  }
}

class _PlayerInfoDisplayState extends ConsumerState<PlayerInfoDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      lowerBound: 0.6,
      value: 1,
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.hasCurrentTurn
                  ? Colors.redAccent[700]!.withOpacity(_controller.value)
                  : PlayerOrderCatalog.fromIndex(
                      widget.game.getPlayerIndex(widget.player),
                    ).color,
              width: widget.hasCurrentTurn ? 5 : 3,
            ),
            color: Colors.white.lighten(20),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(widget.hasCurrentTurn ? 1 : 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const Divider(height: 3, thickness: 1),
              _buildStatusInfo(),
            ],
          ),
        ),
      );

  Widget _buildHeader() => Flexible(
        child: Row(
          children: [
            _buildTargetIcon(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: PlayerIcon(
                index: widget.playerIndex,
                isHighlighted:
                    widget.game.currentPlayerIndex == widget.playerIndex,
              ),
            ),
            OwnText(text: widget.player.displayName, translate: false),
            const Spacer(),
            IconWithNumber(
              iconData: Icons.emoji_events,
              displayNum: widget.player.pointTotal,
              tooltip: 'PLAYERINFO:totalPoints',
              iconSize: 20,
            ),
          ],
        ),
      );

  Widget _buildTargetIcon() {
    final userPlayer = widget.game.getPlayer(ref.user) as TBPlayer;
    if (!userPlayer.role.isPlayerSelected(
      widget.game,
      widget.game.getPlayerIndex(widget.player),
    )) {
      return const SizedBox();
    }
    return Tooltip(
      message: 'roleTargetsPlayerTooltip'
          .tr(namedArgs: {'role': userPlayer.roleKey.locName.tr()}),
      child: const Padding(
        padding: EdgeInsets.only(right: 3),
        child: Icon(
          Icons.center_focus_strong,
          color: Colors.redAccent,
          size: 15,
        ),
      ),
    );
  }

  Widget _buildStatusInfo() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: RoleIcon(roleKey: widget.player.roleKey)),
          const SizedBox(width: 2),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconWithNumber(
                iconData: Icons.done_outline,
                displayNum: widget.player.tricksWon,
                tooltip: 'PLAYERINFO:tricksWon',
                iconSize: 20,
              ),
              IconWithNumber(
                iconData: Icons.new_releases_outlined,
                displayNum: widget.player.calculateCurrentPoints(widget.game),
                tooltip: 'PLAYERINFO:currentPoints',
                iconSize: 20,
              ),
            ],
          ),
        ],
      );
}
