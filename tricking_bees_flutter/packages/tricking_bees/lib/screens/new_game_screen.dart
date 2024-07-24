import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_core/tb_core.dart';

import '../codegen/annotations/screen.dart';
import '../util/app_gradients.dart';
import '../util/widget_ref_extension.dart';
import '../widgets/own_button.dart';
import '../widgets/own_counter.dart';
import '../widgets/own_switch.dart';
import '../widgets/own_text.dart';
import '../widgets/own_text_field.dart';
import 'game_screen.r.dart';

/// The home screen of the app.
@Screen()
class NewGameScreen extends ConsumerStatefulWidget {
  /// Creates a [NewGameScreen].
  const NewGameScreen({super.key});

  @override
  ConsumerState<NewGameScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<NewGameScreen> {
  late Game _game;

  @override
  void initState() {
    super.initState();
    _game = Game();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const OwnText(text: 'HEAD:newGame', type: OwnTextType.title),
          backgroundColor: Colors.black26,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildVisibilityOptions(),
                  const SizedBox(height: 5),
                  _buildInGameOptions(),
                  const Spacer(),
                  OwnButton(
                    text: 'CreateGame',
                    onPressed: _startGame,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// Options to change the visibility of the game to other users.
  Widget _buildVisibilityOptions() => Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: AppGradients.indigoToYellow,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: OwnText(
                text: 'NEWGAME:visibilityOptionsHeader',
                type: OwnTextType.subtitle,
              ),
            ),
            const Divider(
              height: 2,
              thickness: 2,
            ),
            Row(
              children: [
                const OwnText(text: 'NEWGAME:gameIdHeader'),
                const SizedBox(width: 5),
                Expanded(
                  child: SelectableText(
                    _game.gameId.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            OwnSwitch(
              firstOptionKey: 'offline',
              secondOptionKey: 'online',
              secondOption: _game.online,
              onChange: (value) {
                setState(() => _game.online = value);
              },
            ),
            if (_game.online) ...[
              const SizedBox(height: 5),
              OwnSwitch(
                firstOptionKey: 'private',
                secondOptionKey: 'public',
                secondOption: _game.public,
                onChange: (value) {
                  setState(() => _game.public = value);
                },
              ),
              if (!_game.public) ...[
                const SizedBox(height: 5),
                OwnTextField(
                  label: 'setGamePassword',
                  initialText: _game.password,
                  onChanged: (value) {
                    setState(() => _game.password = value);
                  },
                ),
              ],
              OwnSwitch(
                firstOptionKey: 'allowSpec',
                secondOptionKey: 'disallowSpec',
                secondOption: !_game.allowSpectators,
                onChange: (value) {
                  setState(() => _game.allowSpectators = !value);
                },
              ),
            ],
          ],
        ),
      );

  /// Options to change the overarching game settings.
  Widget _buildInGameOptions() => Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: AppGradients.indigoToYellow,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: OwnText(
                text: 'NEWGAME:inGameOptionsHeader',
                type: OwnTextType.subtitle,
              ),
            ),
            const Divider(
              height: 2,
              thickness: 2,
            ),
            _buildPlayerNumSelection(),
            _buildSubgameNumSelection(),
            _buildShuffleCheckbox(),
          ],
        ),
      );

  Widget _buildPlayerNumSelection() => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.white.withAlpha(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            children: [
              const SizedBox(
                width: 120,
                child: OwnText(text: 'NEWGAME:playerNum'),
              ),
              Expanded(
                child: OwnCounter(
                  initialVal: _game.playerNum,
                  minVal: 3,
                  maxVal: 6,
                  isEditable: false,
                  onChanged: (value) {
                    setState(() {
                      _game
                        ..playerNum = value
                        ..subgameNum = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSubgameNumSelection() => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.white.withAlpha(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            children: [
              const SizedBox(
                width: 120,
                child: OwnText(text: 'NEWGAME:subgameNum'),
              ),
              Expanded(
                child: OwnCounter(
                  initialVal: _game.subgameNum,
                  minVal: 1,
                  maxVal: 20,
                  onChanged: (value) {
                    _game.subgameNum = value;
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildShuffleCheckbox() => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.white.withAlpha(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            children: [
              const SizedBox(
                width: 120,
                child: OwnText(text: 'NEWGAME:playerOrder'),
              ),
              OwnSwitch(
                firstOptionKey: 'manual',
                secondOptionKey: 'random',
                secondOption: _game.shufflePlayers,
                onChange: (value) {
                  setState(() {
                    _game.shufflePlayers = value;
                  });
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      );

  /// Starts the game.
  Future<void> _startGame() async {
    final router = GoRouter.of(context);
    if (ref.user == null) {
      throw Exception('No user found in ref.');
    }
    await _game.startLobby(ref.user!);
    await router.pushNamed(
      GameScreenRouting.path,
      pathParameters: {'gameId': _game.id},
    );
  }
}
