import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCYu-H7VWMWizZQgh1NujXVqySpaOFxIbw",
      authDomain: "telefaune-f3516.firebaseapp.com",
      projectId: "telefaune-f3516",
      storageBucket: "telefaune-f3516.appspot.com",
      messagingSenderId: "502701430063",
      appId: "1:502701430063:web:18324ab3de5467dd883dda",
    ),
  );
  runApp(const TelefauneApp());
}

class TelefauneApp extends StatelessWidget {
  const TelefauneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Téléfaune',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Téléfaune')),
      body: const Center(child: Text('Bienvenue sur ton Téléfaune 🦎')),
    );
  }
}
