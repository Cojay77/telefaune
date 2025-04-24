import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ObservationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ObservationDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final date = (data['date'] as Timestamp?)?.toDate();
    final photoUrl = data['photoUrl'] as String?;

    return Scaffold(
      appBar: AppBar(title: const Text("Détail de l'observation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (photoUrl != null && photoUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(photoUrl, fit: BoxFit.cover),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.pets, size: 100, color: Colors.grey),
              ),
            const SizedBox(height: 20),
            Text(
              data['espece'] ?? 'Espèce inconnue',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (date != null)
              Text("📅 ${date.day}/${date.month}/${date.year}",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center),
            const Divider(height: 30),
            if (data['notes'] != null && data['notes'].toString().isNotEmpty)
              Text(
                "📝 Notes :\n${data['notes']}",
                style: const TextStyle(fontSize: 16),
              ),
            if (data['latitude'] != null && data['longitude'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "📍 Localisation :\nLat: ${data['latitude']}, Lon: ${data['longitude']}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            if (data['latitude'] != null && data['longitude'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("🌍 Carte :",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 220,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter:
                              LatLng(data['latitude'], data['longitude']),
                          initialZoom: 14.5,
                          interactiveFlags: InteractiveFlag.all,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.example.telefaune',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 60,
                                height: 60,
                                point:
                                    LatLng(data['latitude'], data['longitude']),
                                child: const Icon(
                                  Icons.location_on,
                                  size: 45,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
