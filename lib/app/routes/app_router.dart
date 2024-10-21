import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vital_eats_2/app/app.dart';
import 'package:vital_eats_2/auth/view/auth_page.dart';
import 'package:vital_eats_2/home/view/home_page.dart';

class AppRouter {
  GoRouter router(AppBloc appBloc) => GoRouter(
    initialLocation: AppRoutes.auth.route,
    routes: [
    GoRoute(
      path: AppRoutes.auth.route,
      name: AppRoutes.auth.name,
      builder: (context, state) => const AuthPage(),
    ),
     GoRoute(
      path: AppRoutes.home.route,
      name: AppRoutes.home.name,
      builder: (context, state) => const MyHomePage(title: 'Vital Eats',),
    ),
  ],
  redirect: (context, state) {
    final authenticated = appBloc.state.status == AppStatus.authenticated;
    final authenticating = state.matchedLocation == AppRoutes.auth.route;
    final isInHome = state.matchedLocation == AppRoutes.home.route;

    if (isInHome && !authenticated) return AppRoutes.auth.route;
    if (!authenticated) return AppRoutes.auth.route;
    if (authenticating && authenticated) {
      return AppRoutes.home.route;
    }
    
    return null;
  },
  refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream)
  ,);
}

class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  /// {@macro go_router_refresh_stream}
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
