import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_repository/location_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:vital_eats_2/map/map.dart';

class GoogleMapPage extends StatelessWidget {
  const GoogleMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(locationRepository: context.read<LocationRepository>(), userRepository: context.read<UserRepository>()),
      child: const GoogleMapView(),
    );
  }
}

class GoogleMapView extends StatelessWidget {
  const GoogleMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      extendBodyBehindAppBar: true,
      safeArea: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.isIOS
            ? SystemUiOverlayTheme.iOSDarkSystemBarTheme
            : SystemUiOverlayTheme.androidDarkSystemBarTheme,
        child: const Stack(
          children: [
            MapView(),
            GoogleMapAddressView(),
            GoogleMapBackButton(),
            GoogleMapSaveLocationButton(),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          final isCameraMoving = state.isCameraMoving;
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: isCameraMoving ? 0 : 1,
            child: FloatingActionButton(
              onPressed: () => context
                  .read<MapBloc>()
                  .add(const MapAnimateToCurrentPositionRequested()),
              elevation: 3,
              shape: const CircleBorder(),
              backgroundColor: AppColors.white,
              child: const AppIcon(
                icon: LucideIcons.circleDot,
                color: AppColors.black,
              ),
            ).ignorePointer(isMoving: isCameraMoving),
          );
        },
      ),
    );
  }
}

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapBloc>();
    final initialCameraPosition = context.select((MapBloc bloc) => bloc.state.initialCameraPosition);
    final mapType = context.select((MapBloc bloc) => bloc.state.mapType);
    final isCameraMoving = context.select((MapBloc bloc) => bloc.state.isCameraMoving);

    return SizedBox(
      height: context.screenHeight,
      width: context.screenWidth,
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) =>
                bloc.add(MapCreateRequested(controller: controller)),
            indoorViewEnabled: !isCameraMoving,
            zoomControlsEnabled: !isCameraMoving,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            padding: const EdgeInsets.fromLTRB(0, 100, 12, 160),
            initialCameraPosition: initialCameraPosition,
            mapType: mapType,
            onCameraMoveStarted: () => bloc.add(
              const MapCameraMoveStartRequested(),
            ),
            onCameraIdle: () => bloc.add(const MapCameraIdleRequested()),
            onCameraMove:(position) => bloc.add(
              MapCameraMoveRequested(position: position),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100, right: AppSpacing.md),
              child: Assets.icons.pinIcon.svg(height: 50, width: 50),
            ),
          ).ignorePointer(isMarker: true),
        ],
      ),
    );
  }
}

extension IgnorePointerX on Widget {
  Widget ignorePointer({bool isMoving = false, bool isMarker = false}) =>
      IgnorePointer(
        ignoring: isMarker || isMoving,
        child: this,
      );
}
