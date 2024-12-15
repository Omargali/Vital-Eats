import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()

/// Location class
class Location extends Equatable {
  ///{@macro location}
  const Location({
    required this.lat,
    required this.lng,
  });

  const Location.undefined() : this(lat: 0, lng: 0);

  factory Location.fromJson(Map<String, dynamic> json) =>
  _$LocationFromJson(json);

  Location copyWith({double? lat, double? lng}) =>
    Location(lat: lat ?? this.lat, lng: lng ?? this.lng);


  final double lat;


  final double lng;
   
  bool get isUnderfined => lat == 0 && lng == 0;

  Map<String, dynamic> toJson() => _$LocationToJson(this);
  
  @override
  List<Object?> get props => [lat, lng];
}
