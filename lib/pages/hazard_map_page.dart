import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HazardMapPage extends StatelessWidget {
  const HazardMapPage({super.key});
  
  static const String apiKey = "D29EGmQHU7kYcqXzFuhd"; // replace with your key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazard Map'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(20.5937, 78.9629), // Center of India
          initialZoom: 5.0,
        ),
        children: [
          // MapTiler Tile Layer
          TileLayer(
            urlTemplate:
                "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$apiKey",
            userAgentPackageName: 'com.example.oceanpulse',
          ),
          
          // Example Hazard Markers
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(15.2993, 74.1240), // Goa coastline
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 35,
                ),
              ),
              Marker(
                point: LatLng(13.0827, 80.2707), // Chennai coastline
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 35,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
