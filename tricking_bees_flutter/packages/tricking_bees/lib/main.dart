import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_framework_ui/flutter_game_framework_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';

import 'design/tb_theme.dart';
import 'screens/game_screen.r.dart';

/// Fill in the following line, if you want to use a local emulated Firebase
/// Environment
// ignore: unreachable_from_main
const emulatorAddress = bool.fromEnvironment('emuMode', defaultValue: false)
    ? 'localhost'
    : null;

void main() async {
  await initialize(
    gameScreenRoute: GameScreenRouting.route,
    gameSetup: TBGame.setup(),
    createNewGame: TBGame.new,
  );
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
        path: 'assets/localizables',
        fallbackLocale: const Locale('en', 'US'),
        assetLoader: MergedAssetLoader([
          'packages/flutter_game_framework_ui/assets/localizables',
          'assets/localizables',
        ]),
        child: GameFramework(lightTheme: tbLightTheme),
      ),
    ),
  );
}
