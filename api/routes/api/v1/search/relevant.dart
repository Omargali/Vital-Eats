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
  final term = context.request.uri.queryParameters['q'];
  if (lat == null || lng == null || term == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final db = await context.futureRead<Connection>();

  final restaurantsView = await db.dbrestaurants.query(
    const SearchRelevantRestaurants(),
    QueryParams(
      values: {'term': '%$term%', 'lat': lat, 'lng': lng},
    ),
  );

  final userLocation = Location(lat: lat, lng: lng);
  final restaurants = restaurantsView
      .map((e) => Restaurant.fromView(e, userLocation: userLocation))
      .toList();

  return Response.json(body: {'restaurants': restaurants});
}
