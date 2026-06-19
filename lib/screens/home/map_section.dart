import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/location_model.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class MapSection extends StatelessWidget {
  final List<LocationModel> locations;
  const MapSection({super.key, required this.locations});

  BitmapDescriptor _markerColor(double rating) {
    if (rating >= 4) return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    if (rating >= 2.5) return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }

  Set<Marker> get _markers => locations.map((loc) => Marker(
    markerId: MarkerId(loc.id),
    position: LatLng(loc.lat, loc.lng),
    icon: _markerColor(loc.rating),
    infoWindow: InfoWindow(
      title: loc.name,
      snippet: '⭐ ${loc.rating.toStringAsFixed(1)}',
      onTap: () => Get.toNamed(AppRoutes.detail.replaceFirst(':id', loc.id)),
    ),
  )).toSet();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 220,
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(target: LatLng(-9.6150, -35.7350), zoom: 12),
          markers: _markers,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}