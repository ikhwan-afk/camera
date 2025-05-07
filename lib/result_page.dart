import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final List<String> detectedAllergies;

  const ResultScreen({super.key, required this.detectedAllergies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Deteksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            detectedAllergies.isEmpty
                ? Center(
                  child: Text(
                    '✅ Tidak ditemukan kandungan alergi.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚠️ Ditemukan kandungan alergi berikut:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...detectedAllergies.map(
                      (allergy) => ListTile(
                        leading: Icon(Icons.warning, color: Colors.red),
                        title: Text(allergy),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
