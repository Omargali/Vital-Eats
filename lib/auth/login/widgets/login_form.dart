import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:form_fields/form_fields.dart';
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<ShadFormState>();
  late ValueNotifier<bool> _obscure;
  

  @override
  void initState() {
    super.initState();
    _obscure = ValueNotifier(true);
  }

  @override
  void dispose() {
    _obscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadForm(
      key: _formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadInputFormField(
              id: 'email',
              label: const Text('Email'),
              placeholder: const Text('Enter your email'),
              prefix: const Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: ShadImage.square(
                  LucideIcons.mail,
                  size: AppSpacing.lg,
                ),
              ),
              validator: (value) {
              final email = Email.dirty(value); 
              return email.errorMessage;
            },
            ),
            const SizedBox(height: AppSpacing.sm),
            ValueListenableBuilder(
              valueListenable: _obscure,
              child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: ShadImage.square(
                      LucideIcons.lock,
                      size: AppSpacing.lg,
                    ),
                  ),
              builder: (context, obscure, prefix) {
                return ShadInputFormField(
                  id: 'password',
                  label: const Text('Password'),
                  placeholder: const Text('Enter your password'),
                  prefix: prefix,
                  obscureText: obscure,
                  suffix: ShadButton.secondary(
                    width: AppSpacing.xlg + AppSpacing.sm,
                    height: AppSpacing.xlg + AppSpacing.sm,
                    padding: EdgeInsets.zero,
                    decoration: const ShadDecoration(
                      secondaryBorder: ShadBorder.none,
                      secondaryFocusedBorder: ShadBorder.none,
                    ),
                    icon: ShadImage.square(
                      size: AppSpacing.lg,
                      obscure ? LucideIcons.eyeOff : LucideIcons.eye,
                    ),
                     onPressed: () {
                        setState(() => _obscure.value = !_obscure.value);
                      },
                  ),
                  validator: (value) {
                    final password = Password.dirty(value);
                    return password.errorMessage;
                  },
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            ShadButton(
              width: double.infinity,
              child: const Text('Login'), 
              onPressed: () {
                if(!(_formKey.currentState?.saveAndValidate() ?? false)){
                  return;
                }
                final email = _formKey.currentState?.value['email'];
                log('Email: $email');
                final password = _formKey.currentState?.value['password'];
                log('Password: $password');
              },
            ),
          ],
        ),
      ),
    );
  }
}
