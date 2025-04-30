import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class AddObservationScreen extends StatefulWidget {
  const AddObservationScreen({super.key});

  @override
  State<AddObservationScreen> createState() => _AddObservationScreenState();
}

class _AddObservationScreenState extends State<AddObservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final especeController = TextEditingController();
  final notesController = TextEditingController();
  String? confirmation;
  String? _categorie;
  XFile? _imageFile;
  String? _photoUrl;
  double? _latitude;
  double? _longitude;

  Future<void> saveObservation() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('observations').add({
      'espece': especeController.text.trim(),
      'categorie': _categorie,
      'notes': notesController.text.trim(),
      'photoUrl': _photoUrl ?? '',
      'utilisateurId': uid,
      'date': DateTime.now(),
      'latitude': _latitude,
      'longitude': _longitude
    });

    setState(() => confirmation = "Observation enregistrée ✅");
    especeController.clear();
    notesController.clear();
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      final storageRef =
          FirebaseStorage.instance.ref().child("observations/$fileName");
      await storageRef.putData(await pickedFile.readAsBytes());
      final url = await storageRef.getDownloadURL();
      setState(() {
        _imageFile = pickedFile;
        _photoUrl = url;
      });
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une observation')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Nouvelle observation",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: especeController,
                decoration: const InputDecoration(
                    labelText: 'Nom de l’animal', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ce champ est requis'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Catégorie"),
                items: [
                  'amphibien',
                  'reptile',
                  'oiseau',
                  'mammifère',
                  'insecte',
                  'tortue',
                  'autre',
                ]
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat[0].toUpperCase() + cat.substring(1)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categorie = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Ce champ est requis'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Notes', border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: pickAndUploadPhoto,
                icon: const Icon(Icons.photo_camera),
                label: const Text("Prendre une photo"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Image.network(_imageFile!.path, height: 200),
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: getCurrentLocation,
                icon: const Icon(Icons.location_on),
                label: const Text("Obtenir ma localisation"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
              if (_latitude != null && _longitude != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("📍 Lat: $_latitude, Lon: $_longitude"),
                ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) saveObservation();
                },
                icon: const Icon(Icons.save),
                label: const Text("Enregistrer l'observation"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              if (confirmation != null) ...[
                const SizedBox(height: 12),
                Text(confirmation!,
                    style: const TextStyle(color: Colors.green)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
