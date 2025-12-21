import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../models/shift_model.dart';

class LocationPage extends StatefulWidget {
  final ShiftModel shift;

  const LocationPage({super.key, required this.shift});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final MapController _mapController = MapController();

  LatLng? currentPosition;
  List<LatLng> routePoints = [];
  bool loadingRoute = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// 📍 Lấy vị trí hiện tại
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    setState(() {
      currentPosition =
          LatLng(position.latitude, position.longitude);
    });

    _mapController.move(currentPosition!, 16);
  }

  /// 🧭 LẤY ĐƯỜNG ĐI THẬT TỪ OSRM
  Future<void> _fetchRouteOSRM() async {
    if (currentPosition == null) return;

    setState(() => loadingRoute = true);

    final startLng = currentPosition!.longitude;
    final startLat = currentPosition!.latitude;
    final endLng = widget.shift.longitude;
    final endLat = widget.shift.latitude;

    final url =
        "https://router.project-osrm.org/route/v1/driving/"
        "$startLng,$startLat;$endLng,$endLat"
        "?overview=full&geometries=geojson";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      final coords =
      data['routes'][0]['geometry']['coordinates'] as List;

      final points = coords
          .map((c) => LatLng(c[1], c[0]))
          .toList();

      setState(() {
        routePoints = points;
        loadingRoute = false;
      });

      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(points),
          padding: const EdgeInsets.all(60),
        ),
      );
    } catch (e) {
      setState(() => loadingRoute = false);
      debugPrint("❌ Lỗi lấy route: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng shiftPosition =
    LatLng(widget.shift.latitude, widget.shift.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Đường đi ca trực"),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: shiftPosition,
          initialZoom: 16,
        ),
        children: [
          /// 🌍 MAP
          TileLayer(
            urlTemplate:
            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.adoan',
          ),

          /// 🟢 VÒNG TRÒN 50M
          CircleLayer(
            circles: [
              CircleMarker(
                point: shiftPosition,
                radius: 50,
                useRadiusInMeter: true,
                color: Colors.green.withOpacity(0.25),
                borderStrokeWidth: 2,
                borderColor: Colors.green,
              ),
              if (currentPosition != null)
                CircleMarker(
                  point: currentPosition!,
                  radius: 50,
                  useRadiusInMeter: true,
                  color: Colors.blue.withOpacity(0.25),
                  borderStrokeWidth: 2,
                  borderColor: Colors.blue,
                ),
            ],
          ),

          /// 📍 MARKER
          MarkerLayer(
            markers: [
              Marker(
                point: shiftPosition,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_pin,
                  size: 45,
                  color: Colors.red,
                ),
              ),
              if (currentPosition != null)
                Marker(
                  point: currentPosition!,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.my_location,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),

          /// 🧭 ĐƯỜNG ĐI THẬT
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  strokeWidth: 5,
                  color: Colors.blue,
                ),
              ],
            ),
        ],
      ),

      /// 🧾 INFO + NÚT VẼ ĐƯỜNG
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: loadingRoute ? null : _fetchRouteOSRM,
              child: Text(
                widget.shift.locationName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.shift.locationAddress,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (loadingRoute)
              const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text("Đang tính đường đi..."),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
