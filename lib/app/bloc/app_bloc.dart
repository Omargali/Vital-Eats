import 'dart:async';

import 'package:api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';



part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required User user,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(
          user.isAnonymous
              ? const AppState.unauthenticated()
              : AppState.authenticated(user),
        ) {
    on<AppUserChanged>(_onAppUserChanged);
    on<AppLogoutRequested>(_onAppLogoutRequested);
    on<AppUpdateAccountRequested>(_onUpdateAccountRequested);
    on<AppDeleteAccountRequested>(_onDeleteAccountRequested);
    on<AppUpdateAccountEmailRequested>(_onUpdateAccountEmailRequested);
    on<AppUserLocationChanged>(_onUserLocationChanged);

    _userSubscription = _userRepository.user.listen(_userChanged, onError: addError);
    _locationSubscription = userRepository
        .currentLocation()
        .listen(_userLocationChanged, onError: addError);
  }

  final UserRepository _userRepository;

  StreamSubscription<User>? _userSubscription;
  StreamSubscription<Location>? _locationSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _userLocationChanged(Location location) =>
      add(AppUserLocationChanged(location));

  void _onAppUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    final user = event.user;
    
    switch(state.status){
      case AppStatus.authenticated:
      case AppStatus.unauthenticated: 
      return emit(
      user.isAnonymous
        ? const AppState.unauthenticated()
        : AppState.authenticated(user),
    );
    }
  }

   Future<void> _onUserLocationChanged(
    AppUserLocationChanged event,
    Emitter<AppState> emit,
  ) async {
    if (state.location == event.location) return;
    emit(state.copyWith(location: event.location));
  }

  Future<void> _onUpdateAccountRequested(
    AppUpdateAccountRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
       await _userRepository.updateProfile(username: event.username);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateAccountEmailRequested(
    AppUpdateAccountEmailRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _userRepository.updateEmail(email: event.email, password: event.password);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }}

 void _onAppLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_userRepository.logOut());
  }

 Future<void> _onDeleteAccountRequested(
    AppDeleteAccountRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _userRepository.deleteAccount();
    } catch (error, stackTrace) {
      await _userRepository.logOut();
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _locationSubscription?.cancel();
    return super.close();
  }
}
