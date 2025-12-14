import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService extends StatefulWidget {
  const LocationService({super.key});

  @override
  State<LocationService> createState() => _LocationServiceState();
}

class _LocationServiceState extends State<LocationService> {
  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<Position>? _positionStream;
  LatLng? _currentPosition;
  Marker? _marker;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndStartTracking();
  }

  Future<void> _checkPermissionAndStartTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    // 🟢 LẤY VỊ TRÍ HIỆN TẠI NGAY KHI APP MỞ
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
      _marker = Marker(
        markerId: const MarkerId("me"),
        position: _currentPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: "Vị trí của tôi"),
      );
    });

    // 🔁 LẮNG NGHE CẬP NHẬT VỊ TRÍ THEO THỜI GIAN
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((Position position) async {
      LatLng newPos = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentPosition = newPos;
        _marker = Marker(
          markerId: const MarkerId("me"),
          position: newPos,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: "Vị trí của tôi"),
        );
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newPos, zoom: 17),
        ),
      );
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Tracking"),
        backgroundColor: const Color(0xFF2375D3),
      ),
      body:
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition!,
                  zoom: 16,
                ),
                markers: _marker != null ? {_marker!} : {},
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),

      // 🟢 FloatingActionButton — thêm ở đây
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2375D3),
        onPressed: () async {
          final pos = await Geolocator.getCurrentPosition();
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)),
          );
        },
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
