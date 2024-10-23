import 'dart:ui' as ui;
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:vital_eats_2/app/bloc/app_bloc.dart';
import 'package:vital_eats_2/profile/widgets/user_credentials_form.dart';


class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();
     final user = context.select((AppBloc bloc) => bloc.state.user);

    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      appBar: AppBar(
        title: const Text('Profile'),
        titleTextStyle: context.headlineSmall,
        centerTitle: false,
        actions: [
          AppIcon.button(icon: LucideIcons.check, onTap: () {
            if (!(formKey.currentState?.validate() ?? false)) return;
            final username =
                  formKey.currentState?.value['username'] as String?;
            if (user.name != username) {
                context
                      .read<AppBloc>()
                      .add(AppUpdateAccountRequested(username: username));
              }
               ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Successfully updated account!'),
                  ),
                );
           },
          ),
          AppIcon.button(
            icon: LucideIcons.alignJustify, 
            onTap: () {
            showMenu(
                context: context,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                position: RelativeRect.fromDirectional(
                  textDirection: ui.TextDirection.ltr,
                  start: AppSpacing.md,
                  top: AppSpacing.md,
                  end: 0,
                  bottom: 0,
                ),
                items: [
                  PopupMenuItem<void>(
                    onTap: () => context.confirmAction(
                      fn: () {
                        context.read<AppBloc>().add(const AppLogoutRequested());
                        context.read<UserRepository>().clearCurrentLocation();
                      },
                      title: 'Logout',
                      content: 'Are you sure to logout from your account?',
                      yesText: 'Yes, logout',
                      noText: 'No, cancel',
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.logOut,
                          size: AppSize.xs,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Log out',
                          style: context.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  ],
            );
          },),
        ],
      ),
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, 
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            UserCredentialsForm(formKey: formKey),
            const SizedBox(height: AppSpacing.md),
            ...ListTile.divideTiles(
              context: context,
              tiles: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                  onTap: () => context.confirmAction(
                    fn: () => context
                        .read<AppBloc>()
                        .add(const AppDeleteAccountRequested()),
                    title: 'Delete account',
                    content: 'Are you sure to permanently delete your account? '
                        'All your data will be deleted.',
                    noText: 'No, keep it',
                    yesText: 'Yes, delete',
                  ),
                  leading: const Icon(LucideIcons.trash),
                  title: const Text('Delete account'),
              ),
            ],),
          ],
        ),
        ),
      );
  }
}
