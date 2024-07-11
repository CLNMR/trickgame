import 'dart:math';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../util/context_extension.dart';
import '../../widgets/in_game/player_information/player_icon.dart';
import '../../widgets/in_game/player_information/player_info_display.dart';
import '../../widgets/own_text.dart';

/// The display screen of the bidding.
class EndDisplay extends ConsumerWidget {
  /// Creates a [EndDisplay].
  const EndDisplay({super.key, required this.game});

  /// The game to show.
  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsHistory = game.getPointsHistory();
    final ranks = game.playerRanks;
    final maxPoints = game.playerPoints.values.toList().reduce(max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const OwnText(text: 'END:endTitle'),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ranks.entries
                .map(
                  (e) => Flexible(
                    child: _buildSingleRank(
                      context,
                      e.value[0],
                      pointsHistory[e.value[0]]!,
                      maxPoints,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleRank(
    BuildContext context,
    int playerIndex,
    List<LogPointsAwarded> pointEntries,
    int maxPoints,
  ) {
    final points = pointEntries.map((e) => e.points).toList();
    final tooltips = pointEntries
        .map(
          (e) => context.trFromObjectToTextSpan(
            TrObject(
              'END:pointTooltip',
              richTrObjects: [
                RichTrObject(RichTrType.number, value: e.points),
                RichTrObject(RichTrType.role, value: e.roleKey),
                RichTrObject(
                  RichTrType.number,
                  value: e.tricksWon,
                  keySuffix: 'Tricks',
                ),
              ],
            ),
            game.shortenedPlayerNames,
          ),
        )
        .toList();
    return Column(
      children: [
        Expanded(
          child: CustomStackedBar(
            points: points,
            tooltips: tooltips,
            maxPoints: maxPoints,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: [
              IconWithNumber(
                iconData: Icons.emoji_events,
                displayNum: points.reduce((a, b) => a + b),
                tooltip: 'PLAYERINFO:totalPoints',
                iconSize: 20,
              ),
              const SizedBox(width: 3),
              PlayerIcon(index: playerIndex),
              const SizedBox(width: 3),
              Expanded(
                child: OwnText(
                  text: game.players[playerIndex].displayName,
                  translate: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}

/// A custom stacked bar chart to display the points of a player.
class CustomStackedBar extends StatelessWidget {
  /// Creates a [CustomStackedBar].
  const CustomStackedBar({
    super.key,
    required this.points,
    required this.tooltips,
    required this.maxPoints,
  })  : assert(
          points.length == tooltips.length,
          'Points and tooltips need to be of same length.',
        ),
        assert(maxPoints > 0, 'maxPoints must be greater than 0.');

  /// The points of the player.
  final List<int> points;

  /// The tooltips for the squares.
  final List<InlineSpan> tooltips;

  /// The maximum amount of points achieved by any player.
  final int maxPoints;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: points.reversed.toList().asMap().entries.map(
            (entry) {
              final index = entry.key;
              final subgame = points.length - index;
              final pointAmount = entry.value;
              final heightFraction = max(pointAmount / maxPoints, 0.001);
              final colorVal =
                  ((subgame - 1) / points.length * 40).ceil().clamp(0, 40);
              return Tooltip(
                richMessage: tooltips[subgame - 1],
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight,
                  ),
                  child: FractionallySizedBox(
                    heightFactor: heightFraction,
                    widthFactor: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.getShadeColor(shadeValue: colorVal),
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(1),
                      ),
                      margin: const EdgeInsets.all(1),
                      child: Center(
                        child: OwnText(
                          trObject: TrObject(
                            'RoundDisplay',
                            args: [subgame.toString()],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<InlineSpan>('tooltips', tooltips))
      ..add(IterableProperty<int>('points', points))
      ..add(IntProperty('maxPoints', maxPoints));
  }
}
