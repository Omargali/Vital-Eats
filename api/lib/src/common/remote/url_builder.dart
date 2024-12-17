class UrlBuilder {
  const UrlBuilder({required String baseUrl}) : _baseUrl = baseUrl;

  final String _baseUrl;

  /// Build parse url for getting restaurant by place id
  Uri getRestaurant({
    required String id,
    String? latitude,
    String? longitude,
  }) =>
      Uri.parse('$_baseUrl/restaurants/$id').replace(
        queryParameters: {
          if (latitude != null) 'lat': latitude,
          if (longitude != null) 'lng': longitude,
        },
      );

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

  /// Build parse url for restaurants by tags.
  Uri getRestaurantsByTags({
    required String latitude,
    required String longitude,
    String? limit,
    String? offset,
  }) {
    return Uri.parse(
      '$_baseUrl/search/by-tags',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );
  }
   
   /// Build parse url for popular restaurants.
   Uri getTags({
    required String latitude,
    required String longitude,
  }) {
    return Uri.parse(
      '$_baseUrl/tags',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
      },
    );
  }

  /// Build parse url for all restaurants
  Uri popularRestaurants({
    required String latitude,
    required String longitude,
  }) {
    return Uri.parse(
      '$_baseUrl/search/popular',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
      },
    );
  }

 /// Build parse url for all restaurants
  Uri relevantRestaurants({
    required String latitude,
    required String longitude,
    required String term,
  }) {
    return Uri.parse(
      '$_baseUrl/search/relevant',
    ).replace(
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'q': term,
      },
    );
  }

  /// Build parse url for restaurants menu by place id
  Uri getMenu(String placeId) => 
      Uri.parse('$_baseUrl/restaurants/$placeId/menu');
}
