
part of 'app_bloc.dart';


enum AppStatus{
  unauthenticated,
  authenticated,
}

class AppState extends Equatable {
  const AppState._({required this.status, required this.user});

  const AppState.authenticated(User user) 
  : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() 
  : this._(status: AppStatus.unauthenticated, user: User.anonymous);

  final AppStatus status;
  final User user;
  
  @override
  List<Object?> get props => [status, user];

  AppState copyWith({
    AppStatus? status,
    User? user,
  }) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
