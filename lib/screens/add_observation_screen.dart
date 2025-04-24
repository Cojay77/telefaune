import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

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
  XFile? _imageFile;
  String? _photoUrl;

  Future<void> saveObservation() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('observations').add({
      'espece': especeController.text.trim(),
      'notes': notesController.text.trim(),
      'photoUrl': _photoUrl ?? '',
      'utilisateurId': uid,
      'date': DateTime.now(),
    });

    setState(() => confirmation = "Observation enregistrée ✅");
    especeController.clear();
    notesController.clear();
  }

  ImagePicker _picker = ImagePicker();

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
