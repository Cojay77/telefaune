import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ObservationListScreen extends StatelessWidget {
  const ObservationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Observations')),
      body: uid == null
          ? const Center(child: Text("Utilisateur non connecté"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Observations')
                  .where('utilisateurId', isEqualTo: uid)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("Aucune observation enregistrée."));
                }

                final observations = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: observations.length,
                  itemBuilder: (context, index) {
                    final obs =
                        observations[index].data() as Map<String, dynamic>;
                    final date = (obs['date'] as Timestamp?)?.toDate();
                    final photoUrl = obs['photoUrl'] as String?;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: photoUrl != null && photoUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(photoUrl,
                                    width: 60, height: 60, fit: BoxFit.cover),
                              )
                            : const Icon(Icons.pets,
                                size: 40, color: Colors.grey),
                        title: Text(obs['espece'] ?? 'Espèce inconnue'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (obs['notes'] != null &&
                                obs['notes'].toString().isNotEmpty)
                              Text(obs['notes'],
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                            if (date != null)
                              Text("📅 ${date.day}/${date.month}/${date.year}"),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
