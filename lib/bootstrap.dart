import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function(SharedPreferences) builder) async{
  await runZonedGuarded(() async{
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp();

      Bloc.observer = AppBlocObserver();
      
      final sharedPreferences = await SharedPreferences.getInstance();

      runApp(await builder(sharedPreferences));
  }, 
  (error, stack) => log('$error', name: 'Error', stackTrace: stack),);
}
