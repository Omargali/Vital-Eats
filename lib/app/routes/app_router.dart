import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vital_eats_2/app/app.dart';
import 'package:vital_eats_2/auth/view/auth_page.dart';
import 'package:vital_eats_2/cart/cart.dart';
import 'package:vital_eats_2/home/view/home_view.dart';
import 'package:vital_eats_2/map/view/map_page.dart';
import 'package:vital_eats_2/map/widgets/search_location_autocomplete.dart';
import 'package:vital_eats_2/menu/menu.dart';
import 'package:vital_eats_2/profile/view/profile_view.dart';
import 'package:vital_eats_2/profile/widgets/user_update_email_form.dart';
import 'package:vital_eats_2/restaurants/view/restaurants_page.dart';
import 'package:vital_eats_2/search/view/search_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  GoRouter router(AppBloc appBloc) => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: AppRoutes.auth.route,
        routes: [
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.auth.route,
            name: AppRoutes.auth.name,
            builder: (context, state) => const AuthPage(),
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.googleMap.route,
            name: AppRoutes.googleMap.name,
            builder: (context, state) => const GoogleMapPage(),
          ),
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: AppRoutes.searchLocation.route,
            name: AppRoutes.searchLocation.name,
            builder: (context, state) => const SearchLocationAutoCompletePage(),
          ),
          GoRoute(
            path: AppRoutes.cart.route,
            name: AppRoutes.cart.name,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: AppRoutes.profile.route,
            name: AppRoutes.profile.name,
            builder: (context, state) => const ProfileView(),
            routes: [
              GoRoute(
                path: AppRoutes.updateEmail.name,
                name: AppRoutes.updateEmail.name,
                builder: (context, state) => const UserUpdateEmailForm(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.search.route,
            name: AppRoutes.search.name,
            builder: (context, state) => const SearchPage(),
          ),
          StatefulShellRoute.indexedStack(
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state, navigationShell) {
              return HomeView(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoutes.restaurants.route,
                    name: AppRoutes.restaurants.name,
                    builder: (context, state) => const RestaurantsPage(),
                    routes: [
                      GoRoute(
                        path: AppRoutes.menu.name,
                        name: AppRoutes.menu.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final props = state.extra! as MenuProps;
                          return MenuPage(props: props);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/go-to-cart',
                    redirect: (context, state) => null,
                  ),
                ],
              ),
            ],
          ),
        ],
        redirect: (context, state) {
          final authenticated = appBloc.state.status == AppStatus.authenticated;
          final hasLocation = !appBloc.state.location.isUnderfined;
          final authenticating = state.matchedLocation == AppRoutes.auth.route;
          final isInRestaurants =
              state.matchedLocation == AppRoutes.restaurants.route;

          if (isInRestaurants && !authenticated) return AppRoutes.auth.route;
          if (!authenticated) return AppRoutes.auth.route;
          if (!hasLocation && authenticating) return AppRoutes.googleMap.route;
          if (authenticating && authenticated) {
            return AppRoutes.restaurants.route;
          }

          return null;
        },
        refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
      );
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
