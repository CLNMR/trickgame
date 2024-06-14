import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

/// A row that holds player information.
class PlayerInfoWidget extends ConsumerWidget {
  /// Creates a [PlayerInfoWidget].
  const PlayerInfoWidget({
    super.key,
    required this.game,
    this.asColumn = false,
  });

  /// The game to show the information for.
  final Game game;

  /// Whether to display it as a column (default is row)
  final bool asColumn;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Game>('game', game))
      ..add(DiagnosticsProperty<bool>('asColumn', asColumn));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ColoredBox(
        color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: asColumn
              ? Column(children: _getInnerWidgets(ref))
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getInnerWidgets(ref),
                ),
        ),
      );

  List<Widget> _getInnerWidgets(WidgetRef ref) => [];
}
