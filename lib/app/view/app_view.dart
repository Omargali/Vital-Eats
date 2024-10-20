import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:vital_eats_2/auth/view/auth_page.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ShadApp.material(
      title: 'Vital Eats',
      themeMode: ThemeMode.light,
      theme: const AppTheme().theme,
      darkTheme: const AppDarkTheme().theme,
      materialThemeBuilder: (context, theme){
        return theme.copyWith(
          appBarTheme: const AppBarTheme(
            surfaceTintColor: AppColors.transparent,
          ),
          textTheme: theme.brightness == Brightness.light 
          ? const AppTheme().textTheme 
          : const AppDarkTheme().textTheme,
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
