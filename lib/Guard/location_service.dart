import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

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
  LatLng? selectedPosition;
  String? selectedTitle;

  List<LatLng> routePoints = [];
  bool loadingRoute = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  /// ===============================
  /// 📍 INIT GPS
  /// ===============================
  Future<void> _initLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (!mounted) return;

    setState(() {
      currentPosition = LatLng(pos.latitude, pos.longitude);
    });
  }

  /// ===============================
  /// 🧭 ROUTE
  /// ===============================
  Future<void> _fetchRoute() async {
    if (currentPosition == null) return;

    setState(() => loadingRoute = true);

    final url = "https://router.project-osrm.org/route/v1/driving/"
        "${currentPosition!.longitude},${currentPosition!.latitude};"
        "${widget.shift.longitude},${widget.shift.latitude}"
        "?overview=full&geometries=geojson";

    try {
      final res = await http.get(Uri.parse(url));
      final data = json.decode(res.body);

      final coords = data['routes'][0]['geometry']['coordinates'] as List;

      final points = coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();

      if (!mounted) return;

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
    }
  }

  /// ===============================
  /// 📌 MOVE MAP
  /// ===============================
  void _focusPoint(LatLng point, String title) {
    setState(() {
      selectedPosition = point;
      selectedTitle = title;
    });
    _mapController.move(point, 17);
  }

  @override
  Widget build(BuildContext context) {
    final shiftPosition = LatLng(widget.shift.latitude, widget.shift.longitude);

    return Scaffold(
      appBar: AppBar(title: const Text("Bản đồ ca trực")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: shiftPosition,
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.adoan',
              ),

              /// ===== CIRCLE =====
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: shiftPosition,
                    radius: 50,
                    useRadiusInMeter: true,
                    color: Colors.green.withOpacity(0.25),
                    borderColor: Colors.green,
                    borderStrokeWidth: 2,
                  ),
                  if (currentPosition != null)
                    CircleMarker(
                      point: currentPosition!,
                      radius: 50,
                      useRadiusInMeter: true,
                      color: Colors.blue.withOpacity(0.25),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                ],
              ),

              /// ===== MARKERS =====
              MarkerLayer(
                markers: [
                  Marker(
                    point: shiftPosition,
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () => _focusPoint(
                        shiftPosition,
                        widget.shift.locationName,
                      ),
                      child: const Icon(
                        Icons.location_pin,
                        size: 45,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  if (currentPosition != null)
                    Marker(
                      point: currentPosition!,
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => _focusPoint(
                          currentPosition!,
                          "Vị trí hiện tại",
                        ),
                        child: const Icon(
                          Icons.my_location,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),

              /// ===== ROUTE =====
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

          /// ===== INFO POPUP =====
          if (selectedPosition != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.place, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedTitle ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            setState(() => selectedPosition = null),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      /// ===== BOTTOM =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: loadingRoute ? null : _fetchRoute,
          icon: const Icon(Icons.directions),
          label: const Text("Vẽ đường từ vị trí hiện tại"),
        ),
      ),
    );
  }
}
