import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../util/context_extension.dart';

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
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ranks.entries
            .map(
              (e) => Flexible(
                flex: 1,
                child: _buildSingleRank(
                  context,
                  pointsHistory[e.value[0]]!,
                  maxPoints,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSingleRank(
    BuildContext context,
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
    return CustomStackedBar(
      points: points,
      tooltips: tooltips,
      maxPoints: maxPoints,
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
  Widget build(BuildContext context) {
    var cumulativePoints = 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: points.asMap().entries.map(
        (entry) {
          final index = entry.key;
          final pointAmount = entry.value;
          final heightFraction = pointAmount / maxPoints;
          cumulativePoints += pointAmount;
          final colorVal =
              (cumulativePoints / maxPoints * 1000).ceil().clamp(100, 1000);
          return Tooltip(
            richMessage: tooltips[index],
            child: FractionallySizedBox(
              heightFactor: heightFraction,
              widthFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber[colorVal],
                  border: Border.all(color: Colors.black),
                ),
                margin: const EdgeInsets.all(1),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<InlineSpan>('tooltips', tooltips))
      ..add(IterableProperty<int>('points', points))
      ..add(IntProperty('maxPoints', maxPoints));
  }
}
