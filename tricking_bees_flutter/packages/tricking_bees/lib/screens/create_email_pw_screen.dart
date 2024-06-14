import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yust/yust.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text_field.dart';

/// The home screen of the app.
@Screen()
class CreateEmailPwScreen extends ConsumerStatefulWidget {
  /// Creates a [CreateEmailPwScreen].
  const CreateEmailPwScreen({super.key});

  @override
  ConsumerState<CreateEmailPwScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<CreateEmailPwScreen> {
  String _alias = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('TrickingBees'),
          backgroundColor: Colors.black26,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                OwnTextField(
                  label: 'Alias',
                  onChanged: (text) => _alias = text,
                  autocorrect: false,
                ),
                const SizedBox(height: 16),
                OwnTextField(
                  label: 'Email',
                  onChanged: (text) => _email = text,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                ),
                const SizedBox(height: 16),
                OwnTextField(
                  label: 'Password',
                  onChanged: (text) => _password = text,
                  obscureText: true,
                  autocorrect: false,
                ),
                const SizedBox(height: 16),
                OwnButton(
                  text: 'CreateAccount',
                  onPressed: () async {
                    try {
                      await Yust.authService
                          .signUp(_alias, '', _email, _password);
                    } on Exception catch (e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
