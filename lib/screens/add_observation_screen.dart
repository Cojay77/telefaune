import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> saveObservation() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('observations').add({
      'espece': especeController.text.trim(),
      'notes': notesController.text.trim(),
      'utilisateurId': uid,
      'date': DateTime.now(),
    });

    setState(() => confirmation = "Observation enregistrée ✅");
    especeController.clear();
    notesController.clear();
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
