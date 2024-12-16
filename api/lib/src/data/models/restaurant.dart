import 'package:api/api.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';


part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant extends Equatable {
  const Restaurant({
    required this.name,
    required this.placeId,
    required this.rating,
    required this.tags,
    required this.imageUrl,
    required this.businessStatus,
    required this.userRatingsTotal,
    required this.openNow,
    required this.location,
    required this.priceLevel,
    required this.deliveryTime,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  factory Restaurant.fromView(
    DbrestaurantView restaurant, {
    required Location userLocation,
  }) {
    final restaurantLocation = Location(
      lat: restaurant.latitude,
      lng: restaurant.longitude,
    );
    var deliveryTime = DeliveryEstimator.estimateDeliveryTime(
      restaurantLocation,
      userLocation,
    ).inMinutes;
    if (deliveryTime <= 5) deliveryTime += 10;
    return Restaurant(
      name: restaurant.name,
      placeId: restaurant.placeId,
      rating: restaurant.rating,
      tags: restaurant.tags.map(Tag.fromName).toList(),
      imageUrl: restaurant.imageUrl,
      businessStatus: restaurant.businessStatus,
      userRatingsTotal: restaurant.userRatingsTotal,
      openNow: restaurant.openNow,
      location: Location(
        lat: restaurant.latitude,
        lng: restaurant.longitude,
      ),
      deliveryTime: deliveryTime,
      priceLevel: restaurant.priceLevel,
    );
  }

  final String name;
  final String placeId;
  final String businessStatus;
  final List<Tag> tags;
  final String imageUrl;
  final dynamic rating;
  final int userRatingsTotal;
  final bool openNow;
  final Location location;
  final int deliveryTime;
  final int priceLevel;

  String get formattedTags => tags.isEmpty
      ? ''
      : tags.length == 1
          ? tags.first.name.capitalized()
          : '${tags.first.name.capitalized()}, ${tags.last.name.capitalized()}';

  String get review {
    final quality = this.quality(rating as num);
    final ratingsTotal = userRatingsTotal;
    return ratingsTotal >= 10 ? '$quality ($ratingsTotal+) ' : 'Few Ratings ';
  }

  bool get isRatingEnough {
    final rating = this.rating;
    return rating is int ? rating > 3 : rating as double > 3.0;
  }

  String get formattedRating =>
      isRatingEnough ? '$rating' : 'Only a few ratings';

  String formattedDeliveryTime() {
    final canDeliveryByWalk = deliveryTime < 8;
    final time = canDeliveryByWalk ? 15 : deliveryTime;
    return '$time - ${time + 10} min';
  }

  String quality(num rating) {
    var ok = false;
    var good = false;
    var perfect = false;

    if (rating is int) {
      ok = rating >= 2;
      good = rating >= 3;
      perfect = rating >= 4;
    } else {
      ok = rating >= 3;
      good = rating <= 4 && rating >= 3.5;
      perfect = rating >= 4.2;
    }

    if (ok) return 'OK';
    if (good) return 'Good';
    if (perfect) return 'Perfect';
    return '';
  }

  /// CopyWith Function is used to copy the object itself to modify only
  /// specific field that needed without touching others.
  Restaurant copyWith({
    String? businessStatus,
    int? priceLevel,
    dynamic rating,
    int? userRatingsTotal,
    String? name,
    String? placeId,
    List<Tag>? tags,
    List<DBMenu>? menu,
    String? imageUrl,
    bool? isFavourite,
    int? deliveryTime,
    Location? location,
    bool? openNow,
  }) {
    return Restaurant(
      location: location ?? this.location,
      openNow: openNow ?? this.openNow,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      businessStatus: businessStatus ?? this.businessStatus,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      priceLevel: priceLevel ?? this.priceLevel,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  @override
  List<Object?> get props => <Object?>[
        name,
        placeId,
        businessStatus,
        tags,
        imageUrl,
        rating,
        userRatingsTotal,
        openNow,
        location,
        priceLevel,
        deliveryTime,
      ];
}

@JsonSerializable()
class Tag extends Equatable {
  const Tag({
    required this.name,
    required this.imageUrl,
  });

  factory Tag.fromName(String name) {
    return Tag(
      name: name,
      imageUrl: Tag.getImageUrl(name),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  final String name;
  final String imageUrl;

  @override
  List<Object?> get props => <Object?>[name, imageUrl];

  Map<String, dynamic> toJson() => _$TagToJson(this);

  static String getImageUrl(String name) => switch (name) {
        'Vegan' =>
          'https://cdn-icons-png.flaticon.com/128/5581/5581173.png',
        'Fresh Ingredients' =>
          'https://cdn-icons-png.flaticon.com/128/9862/9862064.png',
        'Sustainable' =>
          'https://cdn-icons-png.flaticon.com/128/8973/8973764.png',
        'Keto-Friendly' =>
          'https://cdn-icons-png.flaticon.com/128/10008/10008886.png',
        'Gluten-Free' =>
          'https://cdn-icons-png.flaticon.com/128/4891/4891616.png',
        'Organic' =>
          'https://cdn-icons-png.flaticon.com/128/8044/8044418.png',
        'Vegetarian' =>
          'https://cdn-icons-png.flaticon.com/128/3778/3778979.png',
        'Local Ingredients' =>
          'https://cdn-icons-png.flaticon.com/512/601/601939.png',
        'Paleo-Friendly' =>
          'https://cdn-icons-png.flaticon.com/512/15412/15412916.png',
        'Low-Calorie' =>
          'https://cdn-icons-png.flaticon.com/512/8357/8357331.png',
        _ => '',
      };
}
