import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../widgets/own_button.dart';

/// The display screen of the bidding.
class RoleSelectionDisplay extends ConsumerWidget {
  /// Creates a [RoleSelectionDisplay].
  const RoleSelectionDisplay({super.key, required this.game});

  /// The id of the game to show.
  final Game game;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Center(
        child: OwnButton(
          text: 'PlayWithoutRoles',
          onPressed: game.finishRoleSelection,
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}
