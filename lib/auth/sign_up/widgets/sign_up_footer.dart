import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vital_eats_2/auth/auth.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? '),
        Tappable.faded(
          child: Text(
            'Login',
            style: context.bodyMedium?.copyWith(fontWeight: AppFontWeight.bold),
          ),
          onTap: () => context.read<AuthCubit>().changeAuth(showLogin: true),
        ),
      ],
    );
  }
}
