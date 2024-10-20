import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:vital_eats_2/auth/login/login.dart';
import 'package:vital_eats_2/auth/sign_up/widgets/widgets.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        resizeToAvoidBottomInset: true,
        releaseFocus: true,
        body: AppConstrainedScrollView(
          padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             WelcomeImage(),
             SizedBox(height: AppSpacing.lg,),
             SignUpForm(),
             SizedBox(height: AppSpacing.md,),
             Spacer(),
             SignUpFooter(),
            ],
          ),
        ),
    );
  }
}
