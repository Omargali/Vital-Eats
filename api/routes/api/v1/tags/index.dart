import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';

Future<Response> onRequest(RequestContext context) async{
  if(context.request.method != HttpMethod.get){
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final lat = context.request.uri.queryParameters['lat'].doubleTryParse();
  final lng = context.request.uri.queryParameters['lng'].doubleTryParse();

  if(lat == null && lng == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final db = await context.futureRead<Connection>();

  final tagsView = await db.dbrestaurants.query(
    const GetRestaurantsTagsByLocation(), 
    QueryParams(
    values: {'lat': lat, 'lng': lng},
    ),
  );

  final tags = tagsView.map(Tag.fromName).toList();

  return Response.json(body: {'tags': tags});
}
