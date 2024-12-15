class UrlBuilder {
  const UrlBuilder({required String baseUrl}) : _baseUrl = baseUrl;

  final String _baseUrl;

  Uri getRestaurants({
    required String latitude,
    required String longitude,
    String? limit,
    String? offset,
  }){
    return Uri.parse(
      '$_baseUrl/restaurants',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        if(limit != null) 'limit': limit,
        if(offset != null) 'offset': offset,
      },
    );
  }
}
