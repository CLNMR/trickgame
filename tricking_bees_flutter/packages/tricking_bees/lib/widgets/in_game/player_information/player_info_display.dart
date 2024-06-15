import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

import '../../own_text.dart';

/// A small widget displaying the player's status.
class PlayerInfoDisplay extends StatefulWidget {
  /// Creates a [PlayerInfoDisplay].
  const PlayerInfoDisplay({
    super.key,
    required this.playerStatusInfo,
  });

  /// The faction of the player.
  final PlayerStatusInfo playerStatusInfo;

  @override
  State<PlayerInfoDisplay> createState() => _PlayerInfoDisplayState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<PlayerStatusInfo>(
        'playerStatusInfo',
        playerStatusInfo,
      ),
    );
  }
}

class _PlayerInfoDisplayState extends State<PlayerInfoDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      lowerBound: 0.5,
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
          width: 200,
          height: 85,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.playerStatusInfo.hasCurrentTurn
                  ? Colors.black.withOpacity(_controller.value)
                  : Colors.white,
              width: widget.playerStatusInfo.hasCurrentTurn ? 5 : 3,
            ),
            color: Colors.white.lighten(20),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding:
                EdgeInsets.all(widget.playerStatusInfo.hasCurrentTurn ? 3 : 5),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const Divider(height: 2, thickness: 1),
                      _buildStatusInfo(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeader() => Flexible(
        child: Row(
          children: [
            OwnText(text: widget.playerStatusInfo.name, translate: false),
            const Spacer(),
          ],
        ),
      );

  Widget _buildStatusInfo() => Flexible(
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconWithNumber(
                iconData: Icons.collections,
                displayNum: widget.playerStatusInfo.cardNum,
                tooltip: 'PLAYERINFO:CardsRemaining',
              ),
            ],
          ),
        ),
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