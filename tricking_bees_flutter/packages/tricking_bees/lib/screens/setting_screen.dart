import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/own_button.dart';

/// The home screen of the app.
@Screen()
class SettingScreen extends ConsumerStatefulWidget {
  /// Creates a [SettingScreen].
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            const Text('Setting'),
            OwnButton(
              text: 'Switch locale',
              onPressed: () async => _changeLocale(context),
            ),
          ],
        ),
      );

  Future<void> _changeLocale(BuildContext context) async {
    await context.setLocale(
      context.locale == const Locale('en', 'US')
          ? const Locale('de', 'DE')
          : const Locale('en', 'US'),
    );
    // setState(() {});
  }
}
