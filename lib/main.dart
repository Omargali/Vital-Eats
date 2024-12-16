import 'package:api/client.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:location_repository/location_repository.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:restaurants_repository/restaurants_repository.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';
import 'package:vital_eats_2/app/app.dart';
import 'package:vital_eats_2/bootstrap.dart';

void main() async {
  await bootstrap((sharedPreferences) async {
     final tokenStorage = InMemoryTokenStorage();
     final firebaseAuthenticationClient = FirebaseAuthenticationClient(
      tokenStorage: tokenStorage,
     );
      final appDio = AppDio();
       
      final apiClient = YandexEatsClient.localhost(dio: appDio);
     
     final persistentStorage
      = PersistentStorage(sharedPreferences: sharedPreferences);
     final persistentListStorage = 
        PersistentListStorage(sharedPreferences: sharedPreferences);
     final userStorage = UserStorage(storage: persistentStorage);
     final userRepository = UserRepository(
      authenticationClient: firebaseAuthenticationClient,
      storage: userStorage,
     );

     final locationRepository = LocationRepository(httpClient: appDio.httpClient);
    

     final restaurantsStorage = RestaurantsStorage(storage: persistentListStorage);
     final restaurantsRepository = RestaurantsRepository(apiClient: apiClient, storage: restaurantsStorage);

     return App(
      user: await userRepository.user.first,
      userRepository: userRepository,
      locationRepository: locationRepository,
      restaurantsRepository: restaurantsRepository,
      );
  }
  );
}
