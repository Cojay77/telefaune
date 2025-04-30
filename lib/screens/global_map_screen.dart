import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:telefaune/utils/interface_utils.dart';

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
          final categorie = data['categorie'];
          final espece = data['espece'] ?? "Espèce inconnue";

          if (lat != null && lon != null) {
            return Marker(
              width: 40,
              height: 40,
              point: LatLng(lat, lon),
              child: Tooltip(
                message: espece,
                child: Tooltip(
                  message: espece,
                  child: Text(
                    emojiForCategorie(categorie),
                    style: const TextStyle(fontSize: 28),
                  ),
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
        options: const MapOptions(
          initialCenter:
              LatLng(46.6034, 1.8883), // Centre France 🇫🇷 par défaut
          initialZoom: 5.5,
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
