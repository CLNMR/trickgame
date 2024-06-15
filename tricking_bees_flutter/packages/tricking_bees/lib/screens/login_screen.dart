import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yust/yust.dart';

import '../codegen/annotations/screen.dart';
import '../widgets/o_auth_button.dart';
import '../widgets/own_button.dart';
import '../widgets/own_text.dart';
import '../widgets/own_text_field.dart';
import 'create_email_pw_screen.r.dart';

/// The home screen of the app.
@Screen()
class LoginScreen extends ConsumerStatefulWidget {
  /// Creates a [LoginScreen].
  const LoginScreen({super.key});

  /// The route to redirect to after a successful sign in.
  final String? redirection = '';

  @override
  ConsumerState<LoginScreen> createState() => _HomeScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('redirection', redirection));
  }
}

class _HomeScreenState extends ConsumerState<LoginScreen> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHeading(),
                _buildLoginWithEmailPw(context),
                _buildCreateAccountButton(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OAuthButton(
                      authMethod: YustAuthenticationMethod.google,
                      redirection: widget.redirection,
                    ),
                    OAuthButton(
                      authMethod: YustAuthenticationMethod.apple,
                      redirection: widget.redirection,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeading() => const OwnText(
        text: 'TrickingBees',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40,
          color: Colors.white,
        ),
        translate: false,
      );

  Widget _buildCreateAccountButton(BuildContext context) => OwnButton(
        text: 'CreateAccount',
        onPressed: _goToCreateEmailPwScreen(context),
      );

  VoidCallback _goToCreateEmailPwScreen(BuildContext context) =>
      () async => context.push(CreateEmailPwScreenRouting.path);

  Widget _buildLoginWithEmailPw(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
              text: 'Login',
              onPressed: () async {
                try {
                  await Yust.authService.signIn(_email, _password);
                  if (context.mounted) context.go('/');
                } on Exception catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
            ),
          ],
        ),
      );

  // LaterTODO: Show mask to choose alias, save alias in first name instead of
  // real name
}