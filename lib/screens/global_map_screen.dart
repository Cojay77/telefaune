import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GlobalMapScreen extends StatefulWidget {
  const GlobalMapScreen({super.key});

  @override
  State<GlobalMapScreen> createState() => _GlobalMapScreenState();
}

class _GlobalMapScreenState extends State<GlobalMapScreen> {
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    loadObservations();
  }

  Future<void> loadObservations() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('observations').get();

    final markers = querySnapshot.docs
        .map((doc) {
          final data = doc.data();
          final lat = data['latitude'];
          final lon = data['longitude'];
          final espece = data['espece'] ?? "Espèce inconnue";

          if (lat != null && lon != null) {
            return Marker(
              width: 40,
              height: 40,
              point: LatLng(lat, lon),
              child: Tooltip(
                message: espece,
                child: const Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.redAccent,
                ),
              ),
            );
          }
          return null;
        })
        .whereType<Marker>()
        .toList();

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carte des observations')),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(46.6034, 1.8883), // Centre France 🇫🇷 par défaut
          zoom: 5.5,
          interactiveFlags: InteractiveFlag.all,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
    );
  }
}
