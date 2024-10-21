part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

final class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final User user;
}

final class AppLogoutRequested extends AppEvent {
  const AppLogoutRequested();
}
