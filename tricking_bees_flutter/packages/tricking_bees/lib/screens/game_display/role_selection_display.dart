import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import '../../util/widget_ref_extension.dart';
import '../../widgets/in_game/player_information/role_icon.dart';
import '../../widgets/own_button.dart';
import '../../widgets/single_card_display.dart';

/// The display screen of the bidding.
class RoleSelectionDisplay extends ConsumerWidget {
  /// Creates a [RoleSelectionDisplay].
  const RoleSelectionDisplay({super.key, required this.game});

  /// The id of the game to show.
  final Game game;
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      Center(child: _buildBody(context, ref));

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    switch (game.inputRequirement) {
      case InputRequirement.selectRole:
        return _buildRoleSelection(context, ref);
      case InputRequirement.selectPlayer:
        return _buildPlayerSelectGrid(context, ref);
      case InputRequirement.selectTrump:
        return _buildTrumpSelectGrid(context, ref);
      case InputRequirement.selectCardToRemove:
        return const Text('CardRemovalPlaceholder'); // _buildCardRemovalArea();
      default:
        return Center(
          child: Column(
            children: [
              const Text('Something went wrong.'),
              OwnButton(
                text: 'To role selection',
                onPressed: () async {
                  game.inputRequirement = InputRequirement.selectRole;
                  await game.save();
                },
              ),
            ],
          ),
        );
    }
  }

  Widget _buildRoleSelection(BuildContext context, WidgetRef ref) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: _buildRoleButtonGrid(context, ref)),
          if (!game.currentRoles.any((e) => e.key != RoleCatalog.noRole))
            OwnButton(
              text: 'SkipOtherRoles',
              onPressed: () async => game.finishRoleSelection(firstTime: true),
            ),
        ],
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
                // : null,
                : game.chooseRole(roleKey), // TODO: For testing purposes
            child: RoleIcon(
              isChoosable: game.canChooseRole(roleKey, ref.user),
              roleKey: roleKey,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrumpSelectGrid(BuildContext context, WidgetRef ref) {
    final availColors = CardColor.getColorsForPlayerNum(game.playerNum);
    final isSelecting = game.currentPlayer.id == game.getPlayer(ref.user!).id;
    return Center(
      child: GridView.builder(
        itemCount: availColors.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final color = availColors[index];
          return SizedBox(
            width: 50,
            height: 50,
            child: SingleCardDisplay(
              cardColor: Color(color.hexValue),
              symbol: '!',
              onTap: () async {
                if (!isSelecting) return;
                await game.selectTrumpColor(color);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerSelectGrid(BuildContext context, WidgetRef ref) {
    final selectingPlayer = game.currentPlayer;
    final players = game.getNonCurrentPlayers();
    final userIsSelecting = selectingPlayer.id == game.getPlayer(ref.user!).id;
    return Center(
      child: GridView.builder(
        itemCount: players.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final player = players[index];
          final playerIndex = game.getNormalPlayerIndex(player);
          final isAlreadySelected =
              selectingPlayer.role.isPlayerSelected(game, playerIndex);
          return SizedBox(
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () async {
                if (!userIsSelecting) return;
                await selectingPlayer.role.selectPlayer(game, playerIndex);
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      Text(player.displayName),
                      Expanded(child: RoleIcon(roleKey: player.roleKey)),
                    ],
                  ),
                  if (isAlreadySelected) const Icon(Icons.check),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}
