import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vital_eats_2/app/bloc/app_bloc.dart';

class UserUpdateEmailForm extends StatefulWidget {
  const UserUpdateEmailForm({super.key});

  @override
  State<UserUpdateEmailForm> createState() => _UserUpdateEmailFormState();
}

class _UserUpdateEmailFormState extends State<UserUpdateEmailForm> {
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
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      appBar: AppBar(
        title: const Text('Update email'),
        titleTextStyle: context.headlineSmall,
        centerTitle: false,
      ),
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            Expanded(
              child: ShadForm(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 462),
                  child: Column(
                    children: [
                      ShadInputFormField(
                        id: 'email',
                        label: const Text('Email'),
                        placeholder: const Text('abc@gmail.com'),
                        prefix: const Padding(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          child: ShadImage.square(
                            size: AppSpacing.lg,
                            LucideIcons.mail,
                          ),
                        ),
                        validator: (value) {
                          final email = Email.dirty(value);
                          return email.errorMessage;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ValueListenableBuilder(
                        valueListenable: _obscure,
                        child: const Padding(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          child: ShadImage.square(
                            size: AppSpacing.lg,
                            LucideIcons.lock,
                          ),
                        ),
                        builder: (context, obscure, prefix) {
                          return ShadInputFormField(
                            id: 'password',
                            label: const Text('Password'),
                            placeholder: const Text('123456'),
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
                              onPressed: () => _obscure.value = !_obscure.value,
                            ),
                            validator: (value) {
                              final password = Password.dirty(value);
                              return password.errorMessage;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ShadButton(
              backgroundColor: AppColors.deepBlue,
              width: double.infinity,
              onPressed: () async {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                final email = _formKey.currentState?.value['email'] as String;
                final password =
                    _formKey.currentState?.value['password'] as String;
                context.read<AppBloc>().add(
                      AppUpdateAccountEmailRequested(
                        email: email,
                        password: password,
                      ),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    duration: 10.seconds,
                    content: const Text(
                      'Verification email sent. Please check your new email'
                      ' and verify.',
                    ),
                  ),
                );

                // ignore: inference_failure_on_instance_creation
                await Future.delayed(const Duration(seconds: 3));

                
                final mailInboxUrl =
                    Uri.parse('https://mail.google.com/mail/u/0/#inbox');
                await launchUrl(mailInboxUrl);

              
                // ignore: use_build_context_synchronously
                context.read<AppBloc>().add(const AppLogoutRequested());
              },
              size: ShadButtonSize.lg,
              child: const Text('Update email'),
            ),
          ],
        ),
      ),
    );
  }
}
