import 'package:flutter/material.dart';
import 'package:flutter_game_framework_ui/flutter_game_framework_ui.dart';
import 'package:tb_core/tb_core.dart';

import 'screens/game_screen.r.dart';

/// Fill in the following line, if you want to use a local emulated Firebase
/// Environment
const emulatorAddress =
    bool.fromEnvironment('emuMode', defaultValue: false) ? 'localhost' : null;

void main() async {
  await initialize(
    gameScreenRoute: GameScreenRouting.route,
    gameSetup: TBGame.setup(),
    createNewGame: TBGame.new,
  );

  runApp(const GameFramework());
}
