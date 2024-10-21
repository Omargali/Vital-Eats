import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';
import 'package:vital_eats_2/app/app.dart';
import 'package:vital_eats_2/bootstrap.dart';

void main() async {
  await bootstrap(() async {
     final tokenStorage = InMemoryTokenStorage();
     
     final firebaseAuthenticationClient = FirebaseAuthenticationClient(
      tokenStorage: tokenStorage,
     );

     final userRepository = UserRepository(
      authenticationClient: firebaseAuthenticationClient,
     );

     return App(
      userRepository: userRepository,
      user: await userRepository.user.first,
      );
  }
  );
}
