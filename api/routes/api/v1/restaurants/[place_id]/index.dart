import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';

Future<Response> onRequest(RequestContext context, String placeId) async {
  return switch (context.request.method) {
    HttpMethod.get => await _onGetRequest(context, placeId),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _onGetRequest(RequestContext context, String placeId) async {
  final db = await context.futureRead<Connection>();

  final lat = context.query('lat').doubleTryParse();
  final lng = context.query('lng').doubleTryParse();

  final restaurantView = await db.dbrestaurants.query(
    const FindRestaurantById(),
    QueryParams(
      values: {
        'place_id': placeId,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      },
    ),
  );
  if (restaurantView == null) return Response(statusCode: HttpStatus.notFound);

  final restaurant = Restaurant.fromView(
    restaurantView,
    userLocation: lat == null || lng == null
        ? const Location.undefined()
        : Location(lat: lat, lng: lng),
  );
  return Response.json(body: {'restaurant': restaurant});
}
