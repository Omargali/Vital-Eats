
part of 'login_cubit.dart';

enum SubmissionStatus{
  initial,
  inProgress,
  success,
  failure;

  bool get isLoading => this == inProgress;
  bool get isSuccess => this == success;
  bool get isFailure => this == failure;
}

class LoginState extends Equatable {
  const LoginState._({required this.status});

  const LoginState.initial() : this._(status: SubmissionStatus.initial);

  final SubmissionStatus status;
  
  @override
  List<Object?> get props => [status];

  LoginState copyWith({
    SubmissionStatus? status,
    dynamic data,
  }) {
    return LoginState._(
      status: status ?? this.status,
    );
  }
}
