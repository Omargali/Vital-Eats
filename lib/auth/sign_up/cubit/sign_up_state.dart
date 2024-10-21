
part of 'sign_up_cubit.dart';


class SignUpState extends Equatable {
  const SignUpState._({required this.status});

  const SignUpState.initial() : this._(status: SubmissionStatus.initial);

  final SubmissionStatus status;
  
  @override
  List<Object?> get props => [status];

  SignUpState copyWith({
    SubmissionStatus? status,
    dynamic data,
  }) {
    return SignUpState._(
      status: status ?? this.status,
    );
  }
}
