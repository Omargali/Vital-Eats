import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final lat = context.request.uri.queryParameters['lat'].doubleTryParse();
  final lng = context.request.uri.queryParameters['lng'].doubleTryParse();

  if (lat == null || lng == null) {
     return Response(statusCode: HttpStatus.badRequest);
  }

  final limit = context.request.uri.queryParameters['limit'].intTryParse();
  final offset = context.request.uri.queryParameters['offset'].intTryParse();

  final db = await context.futureRead<Connection>();

  final restaurantsView = await db.dbrestaurants.query(
    const GetPopularRestaurantsByLocation(),
    QueryParams(
      limit: limit,
      offset: offset,
      values: {'lat': lat, 'lng': lng},
    ),
  );

  final userLocation = Location(lat: lat, lng: lng);
  final restaurants = restaurantsView
      .map((e) => Restaurant.fromView(e, userLocation: userLocation))
      .toList();

  return Response.json(body: {'restaurants': restaurants});
}
