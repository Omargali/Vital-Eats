import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required UserRepository userRepository})
   : _userRepository = userRepository, 
   super(const LoginState.initial());

  final UserRepository _userRepository;

  Future<void> onSubmit({
    required String email,
    required String password,
    }) async{
      try {
        emit(state.copyWith(status: SubmissionStatus.inProgress));
        await _userRepository.logInWithPassword(
          email: email,
          password: password,
        );
        emit(state.copyWith(status: SubmissionStatus.success));
      } catch (error, stackTrace) {
        addError(error, stackTrace);
        emit(state.copyWith(status: SubmissionStatus.failure));
      }
  }
}
