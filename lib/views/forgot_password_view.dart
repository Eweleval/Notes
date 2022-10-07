import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/extensions/extensions.dart';
import 'package:notes/services/auth/auth.dart';
import 'package:notes/utilities/dialogs/dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contexts1 = showPasswordResetSentDialog(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        final contexts = await showErrorDialog(
          context,
          context.loc.forgot_password_view_generic_error,
        );
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await contexts1;
          }
          if (state.exception != null) {
            contexts;
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.forgot_password),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  context.loc.forgot_password_view_prompt,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: context.loc.email_text_field_placeholder,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: Text(
                    context.loc.forgot_password_view_send_me_link,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: Text(
                    context.loc.forgot_password_view_back_to_login,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
