import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:user_repository/src/models/models.dart';
import 'package:user_repository/user_repository.dart';
/// {@template user_repository}
/// A repository that handles user-related actions and authentication flows.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  const UserRepository({
    required AuthenticationClient authenticationClient,
  })  : _authenticationClient = authenticationClient;

  final AuthenticationClient _authenticationClient;

  /// Stream of [User] which will emit the current user when
  /// the authentication state or the subscription plan changes.
  ///
  Stream<User> get user => _authenticationClient.user
      .map((user) => User.fromAuthenticationUser(authenticationUser: user));

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      await _authenticationClient.logInWithGoogle();
    } on LogInWithGoogleFailure {
      rethrow;
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithPasswordFailure] if an exception occurs.
  Future<void> logInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.logInWithPassword(
        email: email,
        password: password,
      );
    } on LogInWithPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithPasswordFailure(error), stackTrace);
    }
  }

  /// Signs up with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithPasswordCanceled] if the flow is canceled by the user.
  /// Throws a [SignUpWithPasswordFailure] if an exception occurs.
  Future<void> signUpWithPassword({
    required String password,
    required String email,
    required String username,
    String? photo,
  }) async {
    try {
      await _authenticationClient.signUpWithPassword(
        email: email,
        password: password,
        username: username,
      );
    } on SignUpWithPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpWithPasswordFailure(error), stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [User.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await _authenticationClient.logOut();
    } on LogOutFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Updates the current user profile.
  Future<void> updateProfile({
    String? username,
  }) async {
    try {
      await _authenticationClient.updateProfile(username: username);
    } on UpdateProfileFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateProfileFailure(error), stackTrace);
    }
  }

  /// Updates the current user profile.
  Future<void> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.updateEmail(email: email, password: password);
    } on UpdateEmailFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateEmailFailure(error), stackTrace);
    }
  }

  /// Deletes the current user account.
  Future<void> deleteAccount() async {
    try {
      await _authenticationClient.deleteAccount();
    } on DeleteAccountFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteAccountFailure(error), stackTrace);
    }
  }
}
