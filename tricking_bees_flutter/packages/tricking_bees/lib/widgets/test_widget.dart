import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tb_core/tb_core.dart';

import '../screens/game_display/end_display.dart';

/// A quick and dirty widget to test some stuff.
class TestWidget extends StatelessWidget {
  /// Creates a [TestWidget].
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Testing',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('TestApp'),
          ),
          body: Center(
            child: TestWithGameWidget(),
          ),
        ),
      );
}

/// A testing widget that contains a game. Manipulate as desired.
class TestWithGameWidget extends StatefulWidget {
  /// Creates a [TestWithGameWidget].
  TestWithGameWidget({super.key})
      : game = Game(
          id: 'test',
          players: List.generate(
            4,
            (index) => Player(
              id: 'p$index',
              displayName: 'P $index',
              pointTotal: index * 2,
            ),
          ),
          playerNum: 4,
          gameState: GameState.finished,
          gameId: GameId.generate(),
          existingLogEntries: {
            1: List.generate(
              4,
              (index) => LogPointsAwarded(
                playerIndex: index % 4,
                roleKey: RoleCatalog.values[index],
                points: index * 2,
                tricksWon: 5,
              ),
            ),
            2: List.generate(
              4,
              (index) => LogPointsAwarded(
                playerIndex: index % 4,
                roleKey: RoleCatalog.values[index],
                points: index * 2,
                tricksWon: 5,
              ),
            ),
          },
        );

  /// The game to test.
  final Game game;
  @override
  TestWithGameWidgetState createState() => TestWithGameWidgetState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Game>('game', game));
  }
}

/// The state of the [TestWithGameWidget].
class TestWithGameWidgetState extends State<TestWithGameWidget> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('test'),
          Flexible(child: EndDisplay(game: widget.game)),
          const Text('test'),
        ],
      );
}
