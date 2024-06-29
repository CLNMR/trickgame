import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../../util/widget_ref_extension.dart';
import '../../own_text.dart';
import 'player_icon.dart';
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
  final Game game;

  /// The player to display info for.
  final Player player;

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
    final userPlayer = widget.game.getPlayer(ref.user!);
    if (!userPlayer.role.isPlayerSelected(
      widget.game,
      widget.game.getPlayerIndex(widget.player),
    )) {
      return const SizedBox();
    }
    return Tooltip(
      message: 'roleTargetsPlayer'
          .tr(namedArgs: {'role': userPlayer.roleKey.locName.tr()}),
      child: const Padding(
        padding: EdgeInsets.only(right: 5),
        child: Icon(
          Icons.center_focus_strong,
          color: Colors.redAccent,
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

/// A widget displaying an icon overlayed with a number.
class IconWithNumber extends StatelessWidget {
  /// Creates an [IconWithNumber].
  const IconWithNumber({
    super.key,
    required this.iconData,
    required this.displayNum,
    this.iconSize = 25,
    this.tooltip = '',
  });

  /// The icon to display in the background.
  final IconData iconData;

  /// The number to display in the foreground.
  final int displayNum;

  /// The size of the icon.
  final double iconSize;

  /// The tooltip to display.
  final String tooltip;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip.tr(),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: iconSize,
              ),
              OutlinedText(
                displayNum.toString(),
                fontSize: 14,
                outlineColor: Colors.black,
                fillColor: Colors.white,
              ),
            ],
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('iconSize', iconSize))
      ..add(IntProperty('displayNum', displayNum))
      ..add(DiagnosticsProperty<IconData>('iconData', iconData))
      ..add(StringProperty('tooltip', tooltip));
  }
}

/// A widget displaying text with an outline.
class OutlinedText extends StatelessWidget {
  /// Creates an [OutlinedText].
  const OutlinedText(
    this.text, {
    super.key,
    this.fontSize = 40,
    this.outlineColor = Colors.black,
    this.fillColor = Colors.white,
    this.strokeWidth = 2,
  });

  /// The text to display.
  final String text;

  /// The size of the text.
  final double fontSize;

  /// The color of the outline.
  final Color outlineColor;

  /// The color of the fill.
  final Color fillColor;

  /// The width of the outline.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          // Outlined text
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..color = outlineColor,
            ),
          ),
          // Solid text
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: fillColor,
            ),
          ),
        ],
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('text', text))
      ..add(DoubleProperty('fontSize', fontSize))
      ..add(ColorProperty('outlineColor', outlineColor))
      ..add(ColorProperty('fillColor', fillColor))
      ..add(DoubleProperty('strokeWidth', strokeWidth));
  }
}
