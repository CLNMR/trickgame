import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tb_core/tb_core.dart';
import 'package:yust/yust.dart';
import 'package:yust_ui/yust_ui.dart';

import 'design/theme_constants.dart';
import 'screens/wg_router.dart';
import 'widgets/test_widget.dart';

/// Fill in the following line, if you want to use a local emulated Firebase
/// Environment
const emulatorAddress =
    bool.fromEnvironment('emuMode', defaultValue: false) ? 'localhost' : null;

// TODO: Add offline check for players - after 2 minutes, write new time,
// after 3 minutes, display as offline

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
  _initAppConfig();

  if (const bool.fromEnvironment('testMode', defaultValue: false)) {
    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('de', 'DE'),
        ],
        path: 'assets/localizables',
        fallbackLocale: const Locale('en', 'US'),
        child: const ProviderScope(
          child: TestWidget(),
        ),
      ),
    );
    return;
  }

  await Yust(forUI: true).initialize(
    firebaseOptions: AppConfig.config.getFirebaseOptions(),
    projectId: AppConfig.config.projectId,
    emulatorAddress: emulatorAddress,
  );

  YustUi.initialize(
    storageUrl: AppConfig.config.storageBucket,
    imagePlaceholderPath: 'assets/image-placeholder.png',
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      path: 'assets/localizables',
      fallbackLocale: const Locale('en', 'US'),
      child: const ProviderScope(
        child: TrickingBees(),
      ),
    ),
  );
}

void _initAppConfig() {
  const env = emulatorAddress != null
      ? OwnEnvironment.emulator
      : String.fromEnvironment('environment', defaultValue: 'dev') == 'prod'
          ? OwnEnvironment.production
          : OwnEnvironment.development;
  final platform = kIsWeb
      ? OwnPlatform.web
      : Platform.isAndroid
          ? OwnPlatform.android
          : OwnPlatform.ios;
  AppConfig.initialize(
    env: env,
    platform: platform,
    emulatorDomain: emulatorAddress,
  );
}

/// The main widget of the app.
class TrickingBees extends ConsumerStatefulWidget {
  /// Creates a [TrickingBees].
  const TrickingBees({super.key});

  @override
  ConsumerState<TrickingBees> createState() => _TrickingBeesState();
}

class _TrickingBeesState extends ConsumerState<TrickingBees> {
  final _router = WGRouter();

  @override
  void initState() {
    super.initState();
    _router.initialize(context, ref);
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: _getBackgroundImage(context),
        child: MaterialApp.router(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: _router.router,
        ),
      );

  BoxDecoration _getBackgroundImage(BuildContext context) {
    // final pathToBackground = 'assets/images/backgrounds/background_'
    //     '${context.isDarkMode ? 'dark' : 'light'}.jpg';
    const pathToBackground = 'assets/images/background.png';
    return const BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(pathToBackground),
      ),
    );
  }
}
