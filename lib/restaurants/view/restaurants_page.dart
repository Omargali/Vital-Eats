import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
        child: ShadButton(
          child: const Text('Open drawer'),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }
}
