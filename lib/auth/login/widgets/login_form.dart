import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:vital_eats_2/app/app.dart';
import 'package:vital_eats_2/auth/login/cubit/login_cubit.dart';

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
    final isLoading =
        context.select((LoginCubit cubit) => cubit.state.status.isLoading);

    return ShadForm(
      key: _formKey,
      enabled: !isLoading,
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
              enabled: !isLoading,
              icon: !isLoading
                  ? const SizedBox.shrink()
                  : const Padding(
                      padding: EdgeInsets.only(right: AppSpacing.md),
                      child: SizedBox.square(
                        dimension: AppSpacing.lg,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
              onPressed: () {
                if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
                  return;
                }
                final email = _formKey.currentState?.value['email'] as String;
                final password = _formKey.currentState?.value['password'] as String;
                context.read<LoginCubit>().onSubmit(
                  email: email, 
                  password: password,
                );
               },
              child: Text(isLoading ? 'Please wait' : 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}
