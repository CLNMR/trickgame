import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_core/tb_core.dart';

import '../screens/game_screen.r.dart';
import '../util/app_gradients.dart';
import '../util/widget_ref_extension.dart';
import 'in_game/player_information/player_icon.dart';
import 'in_game/player_information/player_info_display.dart';
import 'own_text.dart';

/// A button that displays a summary of a game and leads to the game screen.
class GameButton extends ConsumerWidget {
  /// Creates a [GameButton].
  const GameButton({super.key, required this.game});

  /// The game to display.
  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.all(5),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              final goRouter = GoRouter.of(context);
              await game.addUser(ref.user!);
              await goRouter.pushNamed(
                GameScreenRouting.path,
                pathParameters: {'gameId': game.id},
              );
            },
            child: Container(
              height: 40,
              width: 400,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
                gradient: AppGradients.indigoToYellow,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: OwnText(text: game.gameId.toString()),
                  ),
                  OwnText(
                    text: (game.createdAt != null)
                        ? DateFormat('MM-dd HH:mm')
                            .format(game.createdAt!.toLocal())
                        : '',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: OwnText(
                      text: 'gameButPlayers'.tr() +
                          game.players
                              .map((player) => player.displayName)
                              .join(' - '),
                      translate: false,
                      ellipsis: true,
                    ),
                  ),
                  const Spacer(),
                  if (game.gameState != GameState.waitingForPlayers) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: OwnText(
                        trObject: TrObject(
                          'RoundDisplay',
                          args: [
                            game.currentRound.toString(),
                          ],
                        ),
                      ),
                    ),
                    IconWithNumber(
                      iconData: Icons.format_list_bulleted,
                      displayNum: game.currentSubgame,
                    ),
                    const OwnText(text: 'gameButConnectiveOf'),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: IconWithNumber(
                      iconData: Icons.numbers,
                      displayNum: game.subgameNum,
                      tooltip: 'gameButSubgameNum'.tr(),
                    ),
                  ),
                  if (game.gameState == GameState.waitingForPlayers) ...[
                    PlayerIcon(
                      index: game.players.length - 1,
                      displayNumber: true,
                    ),
                    const OwnText(text: 'gameButConnectiveOf'),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: PlayerIcon(
                      index: game.playerNum - 1,
                      displayNumber: true,
                      tooltip: 'gameButPlayerNum'.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}
