import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yust/yust.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/own_button.dart';

/// The home screen of the app.
@Screen()
class AccountScreen extends ConsumerStatefulWidget {
  /// Creates a [AccountScreen].
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black26,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Account'),
              OwnButton(text: 'Logout', onPressed: _logout),
            ],
          ),
        ),
      );

  Future<void> _logout() async {
    await Yust.authService.signOut();
  }
}
