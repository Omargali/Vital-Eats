import 'package:api/src/data/models/postgres/postgres.dart';
import 'package:stormberry/stormberry.dart';

part 'db_restaurant.schema.dart';

@Model(tableName: 'Restaurant')
abstract class DBRestaurant {
  @PrimaryKey()
  String get placeId;

  String get name;

  String get businessStatus;

  List<String> get tags;

  List<DBMenu>? get menu;

  String get imageUrl;

  double get rating;

  int get userRatingsTotal;

  int get priceLevel;

  bool get openNow;

  bool get popular;

  double get latitude;

  double get longitude;
}
