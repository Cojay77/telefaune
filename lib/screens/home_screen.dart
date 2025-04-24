import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Téléfaune'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bienvenue dans Téléfaune 🦎"),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/add'),
              icon: const Icon(Icons.add_location_alt),
              label: const Text("Nouvelle observation"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/list'),
              child: const Text("Voir mes observations"),
            )
          ],
        ),
      ),
    );
  }
}
