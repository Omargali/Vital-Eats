import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_repository/location_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:vital_eats_2/app/app.dart';

class App extends StatelessWidget {
  const App(
      {required this.user,
      required this.userRepository,
      required this.locationRepository,
      super.key,});

  final User user;
  final UserRepository userRepository;
  final LocationRepository locationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: userRepository,),
        RepositoryProvider.value(value: locationRepository,),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        child: const AppView(),
      ),
    );
  }
}
