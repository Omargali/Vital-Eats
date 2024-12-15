import 'package:api/api.dart';
import 'package:stormberry/stormberry.dart';

class GetRestaurantsByLocation 
extends Query<List<DbrestaurantView>, QueryParams> {
  const GetRestaurantsByLocation();

  @override
  Future<List<DbrestaurantView>> apply(Session db, QueryParams params) async{
    final queryable = DbrestaurantViewQueryable();
    final tableName = queryable.tableAlias;
      final query = """
      SELECT * FROM "$tableName"
      WHERE earth_distance(
      ll_to_earth(@lat, @lng),
      ll_to_earth(latitude, longitude)
    ) <= 150000
      ${params.orderBy != null ? "ORDER BY ${params.orderBy}" : ""}
      ${params.limit != null ? "LIMIT ${params.limit}" : ""}
      ${params.offset != null ? "OFFSET ${params.offset}" : ""}
    """;

    final postgreSQLResult =
        await db.execute(Sql.named(query), parameters: params.values);

    return postgreSQLResult
        .map((row) => queryable.decode(TypedMap(row.toColumnMap())))
        .toList();
  }
}
