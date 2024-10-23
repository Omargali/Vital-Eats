part of 'map_bloc.dart';

enum MapStatus{
  initial,
  loading,
  success,
  failure,
  fetchingAddressLoading,
  fetchingAddressSuccess,
  fetchingAddressFailure;

  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
  bool get isFailure => this == failure;
  bool get isAddressFetchingLoading => this == fetchingAddressLoading;
  bool get isAddressFetchingSucces => this == fetchingAddressSuccess;
  bool get isAddressFetchingFailure => this == fetchingAddressFailure;
}

class MapState extends Equatable {
  const MapState._({
    required this.addressName, 
    required this.isCameraMoving, 
    required this.mapController, 
    required this.initialCameraPosition,
    required this.mapType, 
    required this.status, 
    required this.currentPosition,
    });

  MapState.initial() 
  : this._(
    addressName: '',
    isCameraMoving: false,
    mapController: Completer<GoogleMapController>(),
    mapType: MapType.normal,
    initialCameraPosition: _initialCamerPosition,
    status: MapStatus.initial, 
    currentPosition: _initialCamerPosition.target,
  );

  static const _almatyCenterPosition = LatLng(43.2364, 76.9185);
  static const _initialCamerPosition =
      CameraPosition(target: _almatyCenterPosition, zoom: 11);

  final String addressName;
  final MapStatus status;
  final bool isCameraMoving;
  final Completer<GoogleMapController> mapController;
  final CameraPosition initialCameraPosition;
  final LatLng currentPosition;
  final MapType mapType;
  
  @override
  List<Object?> get props => [
    status, 
    currentPosition, 
    addressName, 
    mapController, 
    initialCameraPosition,
    mapController,
    currentPosition,
    isCameraMoving,
    ];

  MapState copyWith({
    String? addressName,
    MapStatus? status,
    bool? isCameraMoving,
    Completer<GoogleMapController>? mapController,
    CameraPosition? initialCameraPosition,
    LatLng? currentPosition,
    MapType? mapType,
  }) {
    return MapState._(
      addressName: addressName ?? this.addressName,
      status: status ?? this.status,
      isCameraMoving: isCameraMoving ?? this.isCameraMoving,
      mapController: mapController ?? this.mapController,
      initialCameraPosition:
          initialCameraPosition ?? this.initialCameraPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      mapType: mapType ?? this.mapType,
    );
  }
}
