import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_core/tb_core.dart';
import 'package:yust/yust.dart';

import '../codegen/annotations/screen.dart';
import '../util/ui_helper.dart';
import '../util/widget_ref_extension.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';
import 'account_screen.r.dart';
import 'game_list_screen.r.dart';
import 'game_screen.r.dart';
import 'join_game_screen.r.dart';
import 'new_game_screen.r.dart';
import 'setting_screen.r.dart';

/// The home screen of the app.
@Screen()
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeading(),
                _buildNewGameButton(context),
                _buildJoinGameButton(context),
                _buildResumeGameButton(context),
                _buildSettingButton(context),
                if (kDebugMode) _buildResumeTestGameButton(context),
                if (kDebugMode) _buildResumeLastGameButton(context),
                _buildTestWidget(context),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeading() => SizedBox(
        height: 100,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: 0,
              child: _buildAvatar(),
            ),
            const OwnText(
              text: 'TrickingBees',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.white,
              ),
              translate: false,
            ),
          ],
        ),
      );

  Widget _buildAvatar() {
    final user = ref.user;
    return GestureDetector(
      onTap: _goToAccountScreen(context),
      child: CircleAvatar(
        backgroundColor: (user == null)
            ? Colors.black
            : UIHelper.getColorFromString(user.email),
        child: Text(
          (user == null) ? 'X' : user.firstName.substring(0, 2).toUpperCase(),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  VoidCallback _goToAccountScreen(BuildContext context) =>
      () async => context.push(AccountScreenRouting.path);

  Widget _buildNewGameButton(BuildContext context) => OwnButton(
        text: 'NewGame',
        onPressed: _goToNewGameScreen(context),
      );

  VoidCallback _goToNewGameScreen(BuildContext context) =>
      () async => context.push(NewGameScreenRouting.path);

  Widget _buildJoinGameButton(BuildContext context) => OwnButton(
        text: 'JoinGame',
        onPressed: _goToJoinGameScreen(context),
      );

  VoidCallback _goToJoinGameScreen(BuildContext context) =>
      () async => context.push(JoinGameScreenRouting.path);

  Widget _buildResumeGameButton(BuildContext context) => OwnButton(
        text: 'ResumeGame',
        onPressed: _goToGameListScreen(context),
      );

  VoidCallback _goToGameListScreen(BuildContext context) =>
      () async => context.push(GameListScreenRouting.path);

  Widget _buildSettingButton(BuildContext context) => OwnButton(
        text: 'Setting',
        onPressed: _goToSettingScreen(context),
      );

  Widget _buildResumeTestGameButton(BuildContext context) => OwnButton(
        text: 'TestGame',
        onPressed: () async =>
            context.push('${GameScreenRouting.path}/pJmDKQL6fjiDyrOq29Tq'),
      );
  Widget _buildResumeLastGameButton(BuildContext context) => OwnButton(
        text: 'LastGame',
        onPressed: () async {
          final game = await GameService.getFirstFromDB(
            orderBy: [
              YustOrderBy(
                field: 'createdAt',
                descending: true,
              ),
            ],
          );
          if (game == null) return;
          // print('Opening game: ${game.id}');
          await context.push('${GameScreenRouting.path}/${game.id}');
        },
      );

  Widget _buildTestWidget(BuildContext context) => Row(
        children: [
          SelectableText('Current user: ${ref.user?.getName()}'),
          if (ref.user == null) const SizedBox(),
          // else
          //   OwnRichText(
          //     trObject: TrObject(
          //       'LOG:unitMoves',
          //       richTrObjects: [
          //         RichTrObject(
          //           RichTrType.coordinate,
          //           value: Coordinates(0, 0),
          //           keySuffix: 'From',
          //         ),
          //         RichTrObject(
          //           RichTrType.coordinate,
          //           value: Coordinates(0, 1),
          //           keySuffix: 'To',
          //         ),
          //         RichTrObject(RichTrType.player, value: 1),
          //       ],
          //     ),
          //     playerNames: ['A', 'B', 'C'],
          //   ),
        ],
      );

  VoidCallback _goToSettingScreen(BuildContext context) =>
      () async => context.push(SettingScreenRouting.path);
}

// class OwnRichText extends ConsumerWidget {
//   const OwnRichText({
//     super.key,
//     required this.trObject,
//     required this.playerNames,
//   });

//   final TrObject trObject;
//   final List<String> playerNames;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) => RichText(
//         text: TextSpan(
//           children: [
//             trFromObjectToTextSpan(context, ref, trObject, playerNames),
//           ],
//         ),
//       );

//   /// Translates a [TrObject] to a stylized [TextSpan].
//   TextSpan trFromObjectToTextSpan(BuildContext context, WidgetRef ref,
//       TrObject trObject, List<String> playerNames) {
//     final translation = context.trFromObject(trObject);
//     if (trObject.richTrObjects == null || trObject.richTrObjects!.isEmpty) {
//       return TextSpan(text: translation);
//     }
//     final richMap =
//         Map.fromEntries(trObject.richTrObjects!.map((e) => 
//MapEntry(e.key, e)));
//     // Search for all remaining named arguments in the translated text, and
//     // replace them manually with the corresponding TextSpan.
//     final exp = RegExp(r'\{(.+?)\}');
//     final spans = <InlineSpan>[];
//     translation.splitMapJoin(
//       exp,
//       onMatch: (m) {
//         final key = m.group(1);
//         if (key != null && richMap.containsKey(key)) {
//           spans.add(richMap[key]!.getEnrichedSpan(this, ref, playerNames));
//         }
//         return '';
//       },
//       onNonMatch: (m) {
//         spans.add(
//           TextSpan(
//             text: m,
//           ),
//         );
//         return '';
//       },
//     );
//     if (trObject.cardKey != null) {
//       spans
//         ..insert(
//           0,
//           RichTrObject(RichTrType.card, value: trObject.cardKey)
//               .getEnrichedSpan(this, playerNames),
//         )
//         ..insert(1, const TextSpan(text: ': '));
//     }
//     if (trObject.eventKey != null) {
//       spans
//         ..insert(
//           0,
//           RichTrObject(RichTrType.event, value: trObject.eventKey)
//               .getEnrichedSpan(this, playerNames),
//         )
//         ..insert(1, const TextSpan(text: ': '));
//     }
//     return TextSpan(children: spans);
//   }
// }
