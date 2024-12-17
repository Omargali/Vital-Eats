import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function(SharedPreferences) builder,
  ) async{
  await runZonedGuarded(
    () async{
      WidgetsFlutterBinding.ensureInitialized();
      SystemUiOverlayTheme.setPortraitOrientation();

      await Firebase.initializeApp();

      Bloc.observer = AppBlocObserver();

       HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getTemporaryDirectory(),
      );
      
      final sharedPreferences = await SharedPreferences.getInstance();

      runApp(await builder(sharedPreferences));
  }, 
  (error, stack) => log('$error', name: 'Error', stackTrace: stack),);
}
