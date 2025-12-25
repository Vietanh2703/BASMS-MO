import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapPage extends StatelessWidget {
  final Map<String, dynamic> location;

  const LocationMapPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final lat = (location["latitude"] as num).toDouble();
    final lng = (location["longitude"] as num).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(location["locationName"]),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lng),
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate:
            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.adoan',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, lng),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
