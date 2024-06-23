import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../util/widget_ref_extension.dart';
import '../../widgets/in_game/player_information/role_icon.dart';
import '../../widgets/own_button.dart';

/// The display screen of the bidding.
class RoleSelectionDisplay extends ConsumerWidget {
  /// Creates a [RoleSelectionDisplay].
  const RoleSelectionDisplay({super.key, required this.game});

  /// The id of the game to show.
  final Game game;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: _buildRoleButtonGrid(context, ref)),
            OwnButton(
              text: 'SkipOtherRoles',
              onPressed: () async => game.finishRoleSelection(firstTime: true),
            ),
          ],
        ),
      );

  Widget _buildRoleButtonGrid(BuildContext context, WidgetRef ref) {
    final choosableRoles = RoleCatalog.allChoosableRoles;
    return GridView.builder(
      shrinkWrap: true,
      itemCount: choosableRoles.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final roleKey = choosableRoles[index];
        return SizedBox(
          height: 70,
          width: 100,
          child: GestureDetector(
            onTap: () async => (game.canChooseRole(roleKey, ref.user))
                ? game.chooseRole(roleKey)
                : null,
            child: RoleIcon(
              isChoosable: game.canChooseRole(roleKey, ref.user),
              roleKey: roleKey,
            ),
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}
