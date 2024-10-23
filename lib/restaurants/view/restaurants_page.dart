import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vital_eats_2/app/app.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RestaurantsView();
  }
}

class RestaurantsView extends StatelessWidget {
  const RestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShadButton(
              child: const Text('Open drawer'),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            ShadButton.outline(
              child: const Text('Go to the map'),
              onPressed: () => context.pushNamed(AppRoutes.googleMap.name),
            ),
          ],
        ),
      ),
    );
  }
}
