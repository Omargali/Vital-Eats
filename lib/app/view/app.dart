import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_repository/location_repository.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:vital_eats_2/app/app.dart';
import 'package:vital_eats_2/map/bloc/location_bloc.dart';
import 'package:vital_eats_2/restaurants/restaurants.dart';

class App extends StatelessWidget {
  const App({
    required this.user,
    required this.userRepository,
    required this.locationRepository,
    required this.restaurantsRepository,
    super.key,
  });

  final User user;
  final UserRepository userRepository;
  final LocationRepository locationRepository;
  final RestaurantsRepository restaurantsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: userRepository,),
        RepositoryProvider.value(value: locationRepository,),
        RepositoryProvider.value(value: restaurantsRepository,),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              user: user,
              userRepository: userRepository,
            ),
          ),
          BlocProvider(
            create: (_) => RestaurantsBloc(
              restaurantsRepository: restaurantsRepository,
              userRepository: userRepository,
            ),
          ),
          BlocProvider(
            create: (_) => LocationBloc(userRepository: userRepository),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}
