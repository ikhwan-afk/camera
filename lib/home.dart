import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:appcamera/camera.dart';
import 'package:appcamera/providers/allergy_provider.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({super.key, required this.cameras});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final allergyProvider = Provider.of<AllergyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Deteksi Alergi")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Pilih Alergi Anda:", style: TextStyle(fontSize: 18)),
          ),
          Expanded(
            child: ListView(
              children:
                  allergyProvider.availableAllergies.map((allergy) {
                    final selected = allergyProvider.isSelected(allergy);
                    return CheckboxListTile(
                      title: Text(allergy),
                      value: selected,
                      onChanged: (_) {
                        allergyProvider.toggleAllergy(allergy);
                      },
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Mengirimkan seluruh alergi yang dipilih ke CameraScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CameraScreen(
                        cameras: widget.cameras,
                        selectedAllergies: allergyProvider.selectedAllergies,
                      ),
                ),
              );
            },
            child: const Text("Mulai Kamera"),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
