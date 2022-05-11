
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gettaxiii/pages/map/widgets/bottom_slide.dart';
import 'package:gettaxiii/pages/map/widgets/search_map_address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/address.dart';
import '../../services/auth.dart';
import '../../services/map_services.dart';
import '../../ui/info_window/custom_info_window.dart';
import 'map_state.dart';

class MapView extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MapView({Key? key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapState>();
    return SizedBox(
      key: key,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ValueListenableBuilder<Address?>(
        valueListenable: state.currentPosition,
        builder: (context, currentPosition, child) {
          if (currentPosition == null) {
            return Center(child: const CircularProgressIndicator());
          }

          return Stack(
            children: [
              ValueListenableBuilder<List<Marker>?>(
                  valueListenable: MapService.instance!.markers,
                  builder: (context, markers, child) {
                    return GoogleMap(
                      mapType: MapType.normal,
                      polylines: state.polylines,
                      markers: markers?.toSet() ?? {},
                      initialCameraPosition: CameraPosition(
                        target: currentPosition.latLng,
                        zoom: 15,
                      ),
                      onMapCreated: state.onMapCreated,
                      onTap: state.onTapMap,
                      onCameraMove: state.onCameraMove,
                    );
                  }),
              CustomInfoWindow(
                controller: MapService.instance!.controller,
                height: MediaQuery.of(context).size.width * 0.12,
                width: MediaQuery.of(context).size.width * 0.4,
                offset: 50,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        AuthService.instance?.logOut();
                        MapService.instance?.dispose();
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: BottomSlider(),
              ),
              state.rideState == RideState.searchingAddress
                  ? Positioned(top: 10, left: 15, right: 15, child: SearchMapBar())
                  : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}

class MapViewWidget extends StatelessWidget {
  const MapViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = MapState();
    return ChangeNotifierProvider(
      create: (_) => state,
      child: MapView(key: ValueKey('map')),
    );
  }
}
